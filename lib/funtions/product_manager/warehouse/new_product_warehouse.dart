import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/product_manager/warehouse/warehouse_controller.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:pet_care/widgets/product_cart.dart';

import '../../../core/colors.dart';
import '../../../widgets/search_field.dart';

class NewProductWarehousePage extends GetView<WarehouseController> {
  const NewProductWarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chọn sản phẩm'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
                children: [
                  SearchField(
                    text: 'Tìm kiếm sản phẩm',
                    onChange: (value) {
                      controller.searchProduct(value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: (controller.productFilter.value.isNotEmpty)
                          ? GridView.builder(
                              // physics: const NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: controller.productFilter.value.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65),
                              itemBuilder: (context, index) {
                                return ProductCart(
                                  product: controller.productFilter[index],
                                  isAdmin: false,
                                  onPick: (product) {
                                    controller.pickProduct(product);
                                  },
                                );
                              })
                          : const Center(child: EmptyDataWidget())),
                ],
              )),
        ));
  }
}
