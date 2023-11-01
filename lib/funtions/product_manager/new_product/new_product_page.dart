import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/new_product/new_product_controllter.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/dropdown.dart';
import 'package:pet_care/widgets/loading.dart';
import 'package:pet_care/widgets/snackbar.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class NewProductPage extends GetView<NewProductController> {
  const NewProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text((controller.product == null)
              ? 'Thêm sản phẩm mới'
              : 'Chỉnh sửa sản phẩm')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Stack(
          children: [
            SingleChildScrollView(
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
                        label: 'Tên sản phẩm',
                        controller: controller.nameController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        label: 'Giá bán sản phẩm',
                        keyboardType: TextInputType.number,
                        controller: controller.priceController,
                        isCurrency: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        label: 'Đơn vị tính',
                        controller: controller.unitController,
                        isCurrency: true,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(() => MyDropDownButton(
                            items: controller.typeProducts.value,
                            value: controller.valueTypeProduct.value,
                            hintText: 'Chọn loại sản phẩm',
                            onChange: (value) {
                              controller.valueTypeProduct.value = value;
                            },
                            onTapLastItem: () {
                              controller.newTypeProduct();
                            },
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: controller.descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Mô tả',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.black38,
                              )),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      AppButton(
                        onPressed: () {
                          if (controller.product == null) {
                            controller.newProduct();
                          } else {
                            controller.editProduct();
                          }
                          if (controller.state.value is StateError) {
                            showErrorSnackBar(context,
                                (controller.state.value as StateError).message);
                          }
                        },
                        text: (controller.product != null)
                            ? 'Chỉnh sửa'
                            : 'Thêm mới',
                        isResponsive: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Obx(() => (controller.state.value is StateLoading)
                  ? const LoadingWidget()
                  : Container()),
            )
          ],
        ),
      ),
    );
  }
}
