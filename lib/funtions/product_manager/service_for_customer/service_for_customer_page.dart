
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/product_manager/service_for_customer/service_for_customer_controller.dart';
import 'package:pet_care/widgets/service_card.dart';

class ServiceForCustomerPage extends GetView<ServiceForCustomerController> {
  const ServiceForCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: controller.services.length,
        itemBuilder: (context, index) {
          return ServiceCard(
            service: controller.services[index],
          );
        },
      ),
    );
  }
}
