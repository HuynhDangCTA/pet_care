
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../model/state.dart';

class RegisterController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  RxBool passwordInVisible = true.obs;
  RxBool repasswordInVisible = true.obs;
  Rx<AppState> state = Rx<AppState>(StateSuccess());

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  void changeHideOrShowRePassword() {
    repasswordInVisible.value = !repasswordInVisible.value;
  }
}