import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/routes/routes_const.dart';

class SplashController extends GetxController {
  String name = 'Tiệm nhà Chuột';

  @override
  void onInit() {
    super.onInit();
    debugPrint('onInit');
  }

  @override
  void onReady() {
    super.onReady();
    goToHome();
  }

  void goToHome() async {
    Future.delayed(
      const Duration(seconds: 2),
          () {
        debugPrint('go');
        Get.offAndToNamed(RoutesConst.login);
      },
    );
  }

}
