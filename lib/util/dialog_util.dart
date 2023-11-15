import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/widgets/loading.dart';

class DialogUtil {
  static void showSnackBar(String message) {
    Get.showSnackbar(GetSnackBar(
      message: message,
      padding: const EdgeInsets.all(15),
      duration: const Duration(seconds: 2),
      borderRadius: 10.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    ));
  }

  static void showLoading() {
    Get.dialog(
      AlertDialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const LoadingWidget())),
      barrierDismissible: false,
      barrierColor: Colors.black12,
    );
  }

  static void hideLoading() {
    Get.back();
  }
}
