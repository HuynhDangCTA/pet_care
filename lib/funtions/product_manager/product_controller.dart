import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_controllter.dart';
import 'package:pet_care/funtions/product_manager/new_service/new_service_controller.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/widgets/dialog_product_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/constants.dart';
import '../../model/product.dart';
import '../../model/state.dart';
import '../../network/firebase_helper.dart';

class ProductController extends GetxController {
  RxList<Product> products = RxList();
  RxList<ServiceModel> services = RxList();
  List<Product> productsGet = [];
  RxBool isExpandProduct = false.obs;
  RxBool isExpandService = false.obs;
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
          Product product = Product(
              id: doc.id,
              name: doc[Constants.name],
              image: doc[Constants.image],
              price: doc[Constants.price],
              amount: doc[Constants.amount]);
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
          ServiceModel service = ServiceModel(
              id: doc.id,
              name: doc[Constants.name],
              image: doc[Constants.image],
              options: doc[Constants.options],
              isByDate: doc[Constants.byDate]);
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

  void newProductOrService() {
    Get.dialog(AlertDialog(
      content: DialogProductService(
        onTapItem1: () {
          Get.back();
          Get.lazyPut(() => NewProductController());
          Get.toNamed(RoutesConst.newProduct);
        },
        onTapItem2: () {
          Get.back();
          Get.lazyPut(() => NewServiceController());
          Get.toNamed(RoutesConst.newService);
        },
      ),
    ));
  }

  void editProduct(Product product) {
    Get.lazyPut(() => NewProductController());
    Get.toNamed(RoutesConst.newProduct, arguments: product);
  }

  void goWarehouse() {
    Get.lazyPut(() => WarehouseController());
    Get.toNamed(RoutesConst.warehouse);
  }

  void showQRCodeProduct(Product product) {
    debugPrint('show');
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
}
