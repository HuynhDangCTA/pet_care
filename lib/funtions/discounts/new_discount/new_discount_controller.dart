import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/discounts/discount_controller.dart';
import 'package:pet_care/model/discount.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';

class NewDiscountController extends GetxController {
  RxBool allProducts = false.obs;
  RxList<Product> selectedProducts = <Product>[].obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  List<Product> products = [];
  RxList<Product> productFilter = <Product>[].obs;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 1));

  @override
  void onInit() async {
    await getAllProduct();
    super.onInit();
  }

  Future getAllProduct() async {
    await FirebaseHelper.getAllProducts().then((value) {
      if (value.docs.isNotEmpty) {
        List<Product> result = [];
        for (var doc in value.docs) {
          Product product =
              Product.fromDocument(doc.data() as Map<String, dynamic>);
          product.id = doc.id;
          if (!product.deleted) {
            result.add(product);
          }
        }
        products = result;
      }
    });
    productFilter.addAll(products);
  }

  void searchProduct(String? name) {
    productFilter.clear();
    if (name == null || name.isEmpty) {
      productFilter.addAll(products);
      return;
    }
    for (var product in products) {
      if (product.name!
          .toLowerCase()
          .trim()
          .contains(name.toLowerCase().trim())) {
        productFilter.add(product);
      }
    }
  }

  void onPick(int index, Product product) {
    product.selected = !product.selected;
    productFilter.value[index].selected = product.selected;
    debugPrint('selected ${productFilter.value[index].selected}');
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product);
    } else {
      selectedProducts.add(product);
    }
    productFilter.refresh();
  }

  Future newDiscount() async {
    String name = nameController.text;
    String discountString = discountController.text;
    if (name.isEmpty || discountString.isEmpty) return;
    if (selectedProducts.isEmpty && !allProducts.value) {
      DialogUtil.showSnackBar('Chọn sản phẩm giảm giá');
      return;
    }
    DialogUtil.showLoading();
    if (allProducts.value) {
      bool isExits = await FirebaseHelper.checkDiscount(fromDate, null);
      if (isExits) {
        DialogUtil.hideLoading();
        DialogUtil.showSnackBar('Đang có chương trình giảm giá đang chạy');
        return;
      }
    } else {
      for (var product in selectedProducts) {
        bool isExits = await FirebaseHelper.checkDiscount(fromDate, product.id);
        if (isExits) {
          DialogUtil.hideLoading();
          DialogUtil.showSnackBar('Đang có chương trình giảm giá đang chạy');
          return;
        }
      }
    }

    Discount discount = Discount(
        name: name,
        discount: int.parse(discountString),
        toDate: toDate,
        fromDate: fromDate,
        isAllProduct: allProducts.value,
        productId: List.generate(selectedProducts.length, (index) {
          return selectedProducts[index].id!;
        }));

    await FirebaseHelper.newDiscount(discount).then((value) {
      DialogUtil.hideLoading();
      DialogUtil.showSnackBar('Thêm thành công');
      discount.id = value.id;
      nameController.clear();
      discountController.clear();
      DiscountController.instants.discounts.add(discount);
    });
  }
}
