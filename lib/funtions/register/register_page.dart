import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/register/register_controller.dart';

import '../../core/colors.dart';
import '../../model/state.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/loading.dart';
import '../../widgets/text_form_field.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                  text: 'ĐĂNG KÝ',
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
                  controller: controller.repasswordController,
                  obscureText: controller.repasswordInVisible.value,
                  suffixIcon: InkWell(
                    child: (controller.repasswordInVisible.value)
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onTap: () {
                      controller.changeHideOrShowRePassword();
                    },
                  ),
                )),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  onPressed: () async {},
                  text: 'Đăng ký',
                  isResponsive: true,
                  fontSize: 18,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Obx(() => Center(
                child: (controller.state.value is StateLoading)
                    ? const LoadingWidget()
                    : Container()))
          ]),
        ),
      ),
    );
  }
}
