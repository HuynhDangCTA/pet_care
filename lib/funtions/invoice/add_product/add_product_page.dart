import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/search_field.dart';

import '../../../widgets/product_cart.dart';

class AddProductPage extends GetView<NewInvoiceController> {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm sản phẩm"),
        actions: [
          IconButton(onPressed: () {
              controller.scannerQR();
          }, icon: Icon(Icons.qr_code_scanner))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Card(
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => (controller.selectedProduct.isNotEmpty)
                      ? ListView.builder(
                          itemCount: controller.selectedProduct.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  controller.inputAmount(
                                      controller.selectedProduct[index]);
                                },
                                title: AppText(
                                  text: controller.selectedProduct[index].name!,
                                ),
                                subtitle: Text(NumberUtil.formatCurrency(
                                    controller.selectedProduct[index].price)),
                                leading: Obx(() => AppText(
                                  text: controller.amountProduct[index]
                                      .toString(),
                                )),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete_outline_outlined),
                                  onPressed: () {
                                    controller.selectedProduct.removeAt(index);
                                    controller.amountProduct.removeAt(index);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const AppText(text: 'Chưa có sản phẩm')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SearchField(
              text: 'Tìm kiếm sản phẩm',
              onChange: (value) {
                controller.searchProduct(value);
              },
            ),
            Expanded(
              flex: 3,
              child: Obx(() => GridView.builder(
                    itemCount: controller.productFilter.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.65),
                    itemBuilder: (context, index) {
                      return ProductCart(
                        isHot: (index < 5) ? true: false,
                        product: controller.productFilter[index],
                        isAdmin: false,
                        onPick: (product) {
                          controller.inputAmount(product);
                        },
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
