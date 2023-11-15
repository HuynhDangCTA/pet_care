import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/loading.dart';
import 'package:pet_care/widgets/snackbar.dart';
import 'package:pet_care/widgets/text_form_field.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.backgroundApp,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25),
          height: size.height,
          width: size.width,
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'images/logo_rebg.png',
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                const Center(
                    child: AppText(
                      text: 'ĐĂNG NHẬP',
                      color: MyColors.primaryColor,
                      isBold: true,
                      size: 22,
                    )),
                const SizedBox(
                  height: 20,
                ),
                const AppText(
                  text: 'Tài khoản',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  label: '',
                  controller: controller.userNameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                const AppText(
                  text: 'Mật khẩu',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => MyTextFormField(
                  label: '',
                  controller: controller.passwordController,
                  obscureText: controller.passwordInVisible.value,
                  suffixIcon: InkWell(
                    child: (controller.passwordInVisible.value)
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onTap: () {
                      controller.changeHideOrShowPassword();
                    },
                  ),
                )),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  onPressed: () async {
                    await controller.login();
                    if (controller.state.value is StateError) {
                      showErrorSnackBar(context, (controller.state.value as StateError).message);
                    }
                  },
                  text: 'Đăng nhập',
                  isResponsive: true,
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 20,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(text: 'Bạn chưa có tài khoản?'),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.goToRegister();
                      },
                      child: const AppText(
                        text: 'Đăng ký ngay',
                        color: MyColors.primaryColor,
                        isBold: true,
                      ),
                    )
                  ],
                )
              ],
            ),
            Obx(() =>
                Center(
                  child: (controller.state.value is StateLoading)
                      ? const LoadingWidget()
                      : Container()
                ))
          ]),
        ),
      ),
    );
  }
}
