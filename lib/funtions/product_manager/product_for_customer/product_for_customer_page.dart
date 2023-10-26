import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/product_manager/product_for_customer/product_for_customer_controller.dart';

import '../../../widgets/product_cart.dart';

class ProductForCustomerPage extends GetView<ProductForCustomerController> {
  const ProductForCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => GridView.builder(
              itemCount: controller.products.value.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7),
              itemBuilder: (context, index) {
                return ProductCart(
                  product: controller.products.value[index],
                  isAdmin: false,
                  isCustomer: true,
                  addToCart: (product) async {
                    await controller.addToCart(product);
                  },
                  onPick: (product) {
                    controller.goToDetail(product);
                  },
                );
              },
            )),
      ),
    );
  }
}
