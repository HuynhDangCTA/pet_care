import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/new_service/new_service_controller.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';

import '../../../widgets/text_form_field.dart';

class NewServicePage extends GetView<NewServiceController> {
  const NewServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text((controller.service == null)
              ? 'Thêm sản phẩm mới'
              : 'Chỉnh sửa sản phẩm')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
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
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Obx(() => controller.image.value != null
                          ? controller.image.value!
                          : const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60,
                              color: Colors.white,
                            )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFormField(
                    label: 'Tên dịch vụ',
                    controller: controller.nameController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            activeColor: MyColors.primaryColor,
                            value: controller.isByDate.value,
                            onChanged: (value) {
                              controller.isByDate.value = value!;
                            },
                          )),
                      const AppText(text: 'Tính tiền theo ngày, giờ.')
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(() => ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.optionControllers.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MyTextFormField(
                                    label: 'Lựa chọn ${index + 1}',
                                    controller:
                                        controller.optionControllers[index],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: MyTextFormField(
                                    controller:
                                        controller.priceControllers[index],
                                    label: 'Giá',
                                    keyboardType: TextInputType.number,
                                    isCurrency: true,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.newOption();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.withOpacity(0.2)),
                          child: const Icon(
                            Icons.add_box_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.deleteOption();
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey.withOpacity(0.2)),
                          child: const Icon(
                            Icons.delete_outline_outlined,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                onPressed: () {
                  controller.newService();
                },
                text: 'Thêm mới',
                isResponsive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
