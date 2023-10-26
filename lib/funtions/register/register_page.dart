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
      appBar: AppBar(
        title: const Text('Đăng ký'),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.backgroundApp,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          // height: size.height,
          width: size.width,
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Obx(() => ClipRRect(
                          borderRadius: BorderRadius.circular(1000),
                          child: controller.image.value)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const AppText(
                  text: 'Họ và tên',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  label: '',
                  controller: controller.fullNameController,
                ),
                const SizedBox(
                  height: 30,
                ),
                const AppText(
                  text: 'Số điện thoại đăng nhập',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  label: '',
                  controller: controller.userNameController,
                  keyboardType: TextInputType.phone,
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
                  text: 'Nhập lại mật khẩu',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => MyTextFormField(
                      label: '',
                      controller: controller.repasswordController,
                      obscureText: controller.repasswordInVisible.value,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != controller.passwordController.text) {
                          return 'Mật khẩu nhập lại không đúng';
                        }
                        return null;
                      },
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
                  height: 30,
                ),
                const AppText(
                  text: 'Địa chỉ',
                  color: MyColors.textColor,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextFormField(
                  label: '',
                  controller: controller.addressController,
                ),
                const SizedBox(
                  height: 30,
                ),
                AppButton(
                  onPressed: () async {
                    await controller.register();
                  },
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
