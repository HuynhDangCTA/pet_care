import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/warehouse.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/loading.dart';
import 'package:pet_care/util/number_util.dart';
import '../../../model/item_warehouse.dart';

class WarehouseController extends GetxController {
  List<Product> products = Get
      .find<ProductController>()
      .productsGet;
  RxList<Product> productFilter = <Product>[].obs;
  Rx<Warehouse?> warehouseItems = Rx(null);
  RxList<TextEditingController> editController = RxList([]);
  RxList<TextEditingController> priceController = RxList([]);

  var selectedDate = DateTime
      .now()
      .obs;

  @override
  void onInit() {
    super.onInit();
    warehouseItems.value = Warehouse([], selectedDate.value);
  }

  void searchProduct(String? value) {
    if (value == null || value.isEmpty) {
      productFilter.clear();
      return;
    }
    productFilter.clear();
    for (Product product in products) {
      if (product.name!
          .toLowerCase()
          .trim()
          .contains(value.toLowerCase().trim())) {
        productFilter.add(product);
      }
    }
  }

  void pickProduct(int index) {
    var item = ItemWarehouse(productFilter[index], 0);
    if (!warehouseItems.value!.proudcts.contains(item)) {
      warehouseItems.value!.proudcts.add(item);
      editController.add(TextEditingController());
      priceController.add(TextEditingController());
    }
    productFilter.clear();
  }

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  String formatDate(value) {
    return DateFormat("dd-MM-yyyy").format(value).toString();
  }

  void newWarehouse() async {
    if (warehouseItems.value == null) return;
    if (warehouseItems.value!.proudcts.isEmpty) return;
    if (editController.isEmpty) return;
    if (priceController.isEmpty) return;

    for (int i = 0; i < editController.length; i++) {
      if (editController[i].text.isEmpty) return;
      warehouseItems.value!.proudcts[i].amount =
          NumberUtil.parseCurrency(editController[i].text).toInt();
      warehouseItems.value?.proudcts[i].product.amount =
      (warehouseItems.value!.proudcts[i].product.amount! +
          NumberUtil.parseCurrency(editController[i].text).toInt());
      warehouseItems.value!.proudcts[i].product.priceInput =
          NumberUtil.parseCurrency(priceController[i].text).toInt();
    }
    Loading.showLoading();
    warehouseItems.value!.timeCreated = selectedDate.value;
    for (var i = 0; i < warehouseItems.value!.proudcts.length; i++) {
      await FirebaseHelper.updateProduct(
        warehouseItems.value!.proudcts[i].product,
      );
    }

    await FirebaseHelper.newWarehouse(warehouseItems.value!).then((value) {
      warehouseItems.value = null;
      editController.clear();
      priceController.clear();
    });
    Loading.hideLoading();
  }
}
