import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/product_for_customer/product_detail_customer/product_detail_customer_controller.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';

class ProductDetailCustomerPage
    extends GetView<ProductDetailCustomerController> {
  const ProductDetailCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                child: Image.network(controller.product.image!),
              ),
              const SizedBox(
                height: 20,
              ),
              AppText(
                text: controller.product.name ?? '',
                color: MyColors.primaryColor,
                isBold: true,
                size: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              AppText(
                text: controller.product.price.toString() ?? '',
                size: 16,
              ),
              const SizedBox(
                height: 20,
              ),
              AppText(
                text: controller.product.description ?? '',
                textAlign: TextAlign.justify,
                size: 16,
              ),
              AppButton(
                onPressed: () {},
                text: 'Thêm vào giỏ hàng',
                isResponsive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
