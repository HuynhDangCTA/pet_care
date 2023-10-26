
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet_care/bindings/all_binding.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/register/register_controller.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/encode_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginController extends GetxController {
  RxBool passwordInVisible = true.obs;
  RxBool cbRemember = false.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString error = ''.obs;
  Rx<AppState> state = Rx<AppState>(StateSuccess());
  late SharedPreferences sharedPref;

  @override
  void onInit() async {
    sharedPref = await SharedPreferences.getInstance();
    super.onInit();
  }

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  Future<void> login() async {
    String name = userNameController.text;
    String password = passwordController.text;
    // String passwordSHA = EncodeUtil.generateSHA256(password);
    UserRequest user = UserRequest(name: name, password: password);
    state.value = StateLoading();
    await FirebaseHelper.login(user).then((value) async {
      if (value != null && value.docs.length > 0) {
        state.value = StateSuccess();
        user.id = value.docs[0].id;
        user.type = value.docs[0][Constants.typeAccount];
        await sharedPref.setString(Constants.users, user.toString());
        await sharedPref.setBool(Constants.saveUser, cbRemember.value);
        if (user.type == Constants.typeCustomer) {
          Get.offAndToNamed(RoutesConst.homeCustomer, arguments: user);
        } else {
          Get.offAndToNamed(RoutesConst.home, arguments: user);
        }
      } else {
        state.value = StateError('Tài khoản hoặc mật khẩu không đúng');
      }
    });
  }


  void goToRegister() {
    Get.lazyPut(() => RegisterController());
    Get.toNamed(RoutesConst.register);
  }

  @override
  void onClose() {
    super.onClose();

  }
}
