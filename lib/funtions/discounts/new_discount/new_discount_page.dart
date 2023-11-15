import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/discounts/new_discount/new_discount_controller.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/date_picker.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class NewDiscountPage extends GetView<NewDiscountController> {
  const NewDiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo khuyến mãi'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              MyTextFormField(
                controller: controller.nameController,
                label: 'Tên chương trình',
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Expanded(child: AppText(text: 'Sản phẩm giảm giá')),
                  Obx(() => (!controller.allProducts.value) ? GestureDetector(
                    onTap: () {
                      Get.toNamed(RoutesConst.selectProduct);
                    },
                    child: const AppText(
                      text: 'Thêm sản phẩm',
                      color: MyColors.primaryColor,
                    ),
                  ) : Container())
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.allProducts.value,
                        onChanged: (value) {
                          controller.allProducts.value = value!;
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const AppText(text: 'Tất cả sản phẩm'),
                    ],
                  )),
              Obx(() => (!controller.allProducts.value)
                  ? Card(
                      color: Colors.white,
                      child: SizedBox(
                        width: Get.width,
                        height: 300,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: controller.selectedProducts.value.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                  controller.selectedProducts[index].image!),
                            );
                          },
                        ),
                      ),
                    )
                  : Container()),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                controller: controller.discountController,
                keyboardType: TextInputType.number,
                label: 'Giảm giá',
              ),
              const SizedBox(
                height: 10,
              ),
              DatePicker(
                hintText: 'Ngày bắt đầu',
                selectedDate: controller.fromDate,
                onChange: (value) {
                  controller.fromDate = value;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DatePicker(
                hintText: 'Ngày kết thúc',
                selectedDate: controller.toDate,
                onChange: (value) {
                  controller.toDate = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              AppButton(
                onPressed: () async {
                  await controller.newDiscount();
                },
                text: 'Thêm',
                isResponsive: true,
                isShadow: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
