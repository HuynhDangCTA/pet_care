import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants.dart';

class SplashController extends GetxController {
  String name = 'Tiệm nhà Chuột';

  @override
  void onInit() {
    super.onInit();
    debugPrint('onInit');
  }

  @override
  void onReady() async {
    super.onReady();
    await goToHome();
  }

  Future goToHome() async {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        final sharedPref = await SharedPreferences.getInstance();
        String? user = sharedPref.getString(Constants.users);
        if (user != null) {
          Get.offAndToNamed(RoutesConst.home);
        } else {
          Get.offAndToNamed(RoutesConst.login);
        }
      },
    );
  }
}
