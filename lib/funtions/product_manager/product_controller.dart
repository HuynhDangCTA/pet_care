import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_controllter.dart';
import 'package:pet_care/funtions/product_manager/new_service/new_service_controller.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/dialog_product_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants.dart';
import '../../model/product.dart';
import '../../model/state.dart';
import '../../network/firebase_helper.dart';

class ProductController extends GetxController {
  RxInt currentStep = 0.obs;
  RxList<Product> products = RxList();
  RxList<ServiceModel> services = RxList();
  List<Product> productsGet = [];
  RxBool isExpandProduct = false.obs;
  RxBool isExpandService = false.obs;
  RxList<String> typeProducts = <String>[].obs;
  Rx<AppState> state = Rx(StateSuccess());

  @override
  void onInit() async {
    super.onInit();
    state.value = StateLoading();
    await getAllProducts();
    await getAllService();
  }

  void searchProduct(String? value) {
    products.clear();
    debugPrint('search: $value, ${productsGet.length}');
    if (value == null || value.isEmpty) {
      products.addAll(productsGet);
    } else {
      for (var item in productsGet) {
        debugPrint('search product: ${item.name}');
        if (item.name!.toLowerCase().contains(value.toLowerCase())) {
          products.value.add(item);
        }
      }
    }
  }

  Future getAllProducts() async {
    state.value = StateLoading();
    products.clear();
    await FirebaseHelper.getAllProducts().then((value) {
      state.value = StateSuccess();
      if (value != null && value.docs.length > 0) {
        List<Product> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          Product product =
              Product.fromDocument(doc.data() as Map<String, dynamic>);
          product.id = doc.id;
          // if (!staff.isDeleted) {
          //   result.add(staff);
          // }
          debugPrint(product.name);
          result.add(product);
        }
        productsGet = result;
        products.addAll(productsGet);
        if (result.isEmpty) {
          state.value = StateEmptyData();
        }
      } else {
        state.value = StateEmptyData();
      }
    });
  }

  Future getAllService() async {
    await FirebaseHelper.getAllServices().then((value) {
      if (value != null && value.docs.length > 0) {
        List<ServiceModel> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          ServiceModel service =
              ServiceModel.fromDocument(doc.data() as Map<String, dynamic>);
          service.id = doc.id;
          result.add(service);
        }
        services.value = result;
        if (result.isEmpty) {
          state.value = StateEmptyData();
        }
      }
    });
  }

  void goToNewProduct() {
    Get.lazyPut(() => NewProductController());
    Get.toNamed(RoutesConst.newProduct);
  }

  void goToNewService() {
    Get.lazyPut(() => NewServiceController());
    Get.toNamed(RoutesConst.newService);
  }

  void editProduct(Product product) {
    Get.toNamed(RoutesConst.newProduct, arguments: product);
  }

  void goWarehouse() {
    Get.toNamed(RoutesConst.warehouse);
  }

  void goProductDetail(Product product) {
    Get.toNamed(RoutesConst.productDetail, arguments: product);
  }

  void goRoomPage() {
    Get.toNamed(RoutesConst.room);
  }

  RxList<bool> valueFillter = <bool>[].obs;
  RxList<String> valueTypeFiller = <String>[].obs;

  void showFillter() async {
    if (typeProducts.isEmpty) {
      await getTypeProducts();
    }

    if (valueFillter.isEmpty) {
      valueFillter.addAll(List.generate(typeProducts.length, (index) => false));
    }

    RxList<bool> valueTemp =
        List.generate(typeProducts.length, (index) => valueFillter[index]).obs;

    Get.defaultDialog(
        title: 'Bộ lọc',
        backgroundColor: Colors.white,
        content: Container(
            width: Get.width,
            height: Get.width,
            // color: Colors.white,
            child: Obx(() => ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        valueTemp[index] = !valueTemp[index];
                      },
                      title: AppText(
                        text: typeProducts.value[index],
                      ),
                      leading: Checkbox(
                        activeColor: MyColors.primaryColor,
                        value: valueTemp.value[index],
                        onChanged: (value) {
                          valueTemp[index] = !valueTemp[index];
                        },
                      ),
                    );
                  },
                  itemCount: valueTemp.value.length,
                ))),
        actions: [
          AppButton(
            onPressed: () {
              valueTypeFiller.clear();
              valueFillter.value = valueTemp.value;
              for (int i = 0; i < valueFillter.length; i++) {
                if (valueFillter[i]) {
                  if (!valueTypeFiller.contains(typeProducts[i])) {
                    valueTypeFiller.add(typeProducts[i]);
                  }
                } else {
                  if (valueTypeFiller.contains(typeProducts[i])) {
                    valueTypeFiller.remove(typeProducts[i]);
                  }
                }
              }

              products.clear();
              if (valueTypeFiller.isEmpty) {
                products.addAll(productsGet);
              }
              for (var item in valueTypeFiller) {
                for (var product in productsGet) {
                  if (product.type == item) {
                    products.add(product);
                  }
                }
              }
              Get.back();
            },
            text: 'Lưu',
          ),
          AppButton(
              onPressed: () {
                valueTemp.clear();
                Get.back();
              },
              text: 'Đóng',
              backgroundColor: MyColors.textColor),
        ]);
  }

  Future getTypeProducts() async {
    await FirebaseHelper.getTypeProducts().then((value) {
      for (var item in value.docs) {
        typeProducts.add(item[Constants.type]);
      }
    });
  }

  void showQRCodeProduct(Product product) {
    Get.defaultDialog(
      title: '',
      content: Container(
        width: Get.width,
        // height: Get.width,
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: BarcodeWidget(
          // height: 100,
          barcode: Barcode.code128(),
          data: product.id!,
        ),
      ),
    );
  }

  void changeScreen(value) {
    currentStep.value = value;
  }
}
