
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/order_customer/order_controller.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt hàng'),),

    );
  }
}
