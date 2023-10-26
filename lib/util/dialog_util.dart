import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DialogUtil {
  static void showSnackBar(String message) {
    Get.showSnackbar(GetSnackBar(
      title: message,
      padding: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    ));
  }
}
