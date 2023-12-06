import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/staff_manager/new_staff/new_staff_controller.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/dropdown.dart';
import 'package:pet_care/widgets/text_form_field.dart';
import '../../../core/colors.dart';

class NewStaffPage extends GetView<NewStaffController> {
  const NewStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: const Text('Thêm nhân viên mới'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  GestureDetector(
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
                  const SizedBox(
                    height: 5,
                  ),
                  const AppText(
                    text: 'Chọn ảnh',
                    color: MyColors.primaryColor,
                    size: 13,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    label: 'Tài khoản',
                    controller: controller.usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tài khoản không được để trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  (controller.staff == null)
                      ? Obx(() => Column(
                        children: [
                          MyTextFormField(
                                label: 'Mật khẩu',
                                controller: controller.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mật khẩu không được để trống';
                                  }
                                  return null;
                                },
                                obscureText: controller.passwordInVisible.value,
                                suffixIcon: InkWell(
                                  child: (controller.passwordInVisible.value)
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                  onTap: () {
                                    controller.changeHideOrShowPassword();
                                  },
                                ),
                              ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ))
                      : Container(),
                  MyTextFormField(
                    label: 'Tên nhân viên',
                    controller: controller.fullNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tên nhân viên không được để trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    label: 'Số điện thoai',
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Số điện thoại không được để trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    label: 'Địa chỉ',
                    controller: controller.addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Địa chỉ không được để trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyDropDownButton(
                    hintText: 'Loại tài khoản',
                    items: [
                      DropDownItem(value: 'staff', text: 'Nhân viên'),
                      DropDownItem(value: 'admin', text: 'Admin')
                    ],
                    onChange: (value) {
                      controller.typeAccount = value;
                    },
                    value: controller.typeAccount,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              AppButton(
                onPressed: () async {
                  if (!controller.isEdit) {
                    await controller.register();
                  } else {
                    await controller.edit();
                  }
                },
                text: 'Thêm',
                isResponsive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
