import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/search_field.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class WarehousePage extends GetView<WarehouseController> {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Nhập hàng')),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              SearchField(
                text: 'Chọn sản phẩm',
                onChange: (value) {
                  controller.searchProduct(value);
                },
              ),
              Obx(() => Container(
                    color: Colors.white,
                    width: size.width,
                    padding: EdgeInsets.all(10),
                    height: (controller.productFilter.isEmpty) ? 0 : 300,
                    child: ListView.builder(
                      itemCount: controller.productFilter.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            controller.pickProduct(index);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 120,
                                      height: 120,
                                      child: Image.network(
                                        controller.productFilter[index].image!,
                                        fit: BoxFit.cover,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: AppText(
                                        text: controller
                                            .productFilter[index].name!,
                                        maxLines: 2),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  controller.pickDate();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: size.width,
                  height: 58,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(() => AppText(
                          text:
                              '${controller.formatDate(controller.selectedDate.value)}')),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => (controller.warehouseItems.value != null)
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          controller.warehouseItems.value!.proudcts.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: size.width,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      width: 80,
                                      height: 80,
                                      child: Image.network(
                                        controller.warehouseItems.value!
                                            .proudcts[index].product.image!,
                                        fit: BoxFit.cover,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: AppText(
                                        text: controller.warehouseItems.value!
                                            .proudcts[index].product.name!,
                                        maxLines: 2),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyTextFormField(
                                controller: controller.editController[index],
                                label: 'Số lượng',
                                keyboardType: TextInputType.number,
                                isCurrency: true,
                              ),
                              const SizedBox(height: 5,),
                              MyTextFormField(
                                controller: controller.priceController[index],
                                label: 'Giá nhập',
                                keyboardType: TextInputType.number,
                                isCurrency: true,
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                    )
                  : Container()),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                onPressed: () {
                  controller.newWarehouse();
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
