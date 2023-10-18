import 'package:get/get.dart';
import 'package:pet_care/widgets/loading.dart';

class Loading {
  static void showLoading() {
    Get.dialog(
        barrierDismissible: false,
        LoadingWidget());
  }

  static void hideLoading() {
    Get.back();
  }
}
