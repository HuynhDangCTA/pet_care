import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/cart/cart_controller.dart';
import 'package:pet_care/widgets/cart_item.dart';

import '../../core/colors.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.textColor,
        appBar: AppBar(
          title: const Text('Giỏ hàng'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.separated(
                itemCount: controller.products.length,
                itemBuilder: (context, index) {
                  return CartItem(
                      product: controller.products[index],
                      onChangeSelected: () {});
                },
                separatorBuilder: (context, index) {
                  return Container(
                    width: Get.width,
                    height: 5,
                    color: MyColors.textColor,
                  );
                },
              )),
            ),

          ],
        ));
  }
}
