import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/dialog_util.dart';

import '../../../core/constants.dart';
import '../../../model/product.dart';
import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';

class ProductForCustomerController extends GetxController {
  RxList<Product> products = RxList();
  Rx<AppState> state = Rx(StateSuccess());
  List<Product> productsGet = [];
  UserRequest user = HomeController.instants.userCurrent!;

  @override
  void onInit() async {
    state.value = StateLoading();
    await getAllProducts();
    super.onInit();
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

  void goToDetail(Product product) {
    Get.toNamed(RoutesConst.productDetailCustomer, arguments: product);
  }

  Future addToCart(Product product) async {
    await FirebaseHelper.getProductFromCart(product.id!, user.id!)
        .then((value) {
      if (value.exists) {
        String amount = value.get(Constants.amount);
        product.amount = int.parse(amount) + 1;
      } else {
        product.amount = 1;
      }
    });

    await FirebaseHelper.addToCart(product, user.id!).then((value) {
      DialogUtil.showSnackBar('Thêm thành công');
    });
  }
}
