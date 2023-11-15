import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet_care/bindings/all_binding.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/register/register_controller.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/services/fcm_service.dart';
import 'package:pet_care/util/encode_util.dart';
import 'package:pet_care/util/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginController extends GetxController {
  RxBool passwordInVisible = true.obs;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxString error = ''.obs;
  Rx<AppState> state = Rx<AppState>(StateSuccess());

  @override
  void onInit() async {
    super.onInit();
  }

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  Future<void> login() async {
    String name = userNameController.text;
    String password = passwordController.text;
    String passwordSHA = EncodeUtil.generateSHA256(password);
    debugPrint('password $passwordSHA');
    UserRequest user = UserRequest(name: name, password: passwordSHA);
    state.value = StateLoading();
    await FirebaseHelper.login(user).then((value) async {
      if (value != null && value.docs.isNotEmpty) {
        state.value = StateSuccess();
        UserResponse userResponse =
            UserResponse.fromMap(value.docs[0].data() as Map<String, dynamic>);
        userResponse.id = value.docs[0].id;
        debugPrint('userlogin: ${value.docs[0].data()}');
        await FCMService.getToken(userResponse.id!);
        await SharedPref.setUser(userResponse);
        if (user.type != Constants.typeCustomer) {
          Get.offAndToNamed(RoutesConst.home, arguments: user);
        } else {
          state.value = StateError('Tài khoản hoặc mật khẩu không đúng');
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
}
