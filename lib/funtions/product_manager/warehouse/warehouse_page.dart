import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/util/number_util.dart';
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
      appBar: AppBar(title: const Text('Nhập hàng')),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
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
              GestureDetector(
                onTap: () {
                  controller.pickDate();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  height: 58,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(
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
              Row(
                children: [
                  const AppText(
                    text: 'Tổng tiền:',
                    isBold: true,
                  ),
                  const SizedBox(width: 10,),
                  Obx(() => AppText(
                      text: NumberUtil.formatCurrency(
                          controller.priceTotal.value)))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.sizeList.value,
                    itemBuilder: (context, index) {
                      String? title = controller
                          .warehouseItems.value!.proudcts![index].product.name;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            controller.pickProduct(controller
                                .warehouseItems.value!.proudcts![index].product);
                          },
                          title: AppText(
                            text: title!,
                          ),
                          leading: AppText(
                            text: controller
                                .warehouseItems.value!.proudcts![index].amount
                                .toString(),
                          ),
                          subtitle: Text(NumberUtil.formatCurrency(controller
                              .warehouseItems.value!.proudcts![index].price)),
                          trailing: IconButton(
                            onPressed: () {
                              controller.deleteItem(index);
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.newProduct();
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
                    onTap: () {},
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
              ),
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
