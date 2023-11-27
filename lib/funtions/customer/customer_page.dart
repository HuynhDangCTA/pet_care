import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/customer/customer_controller.dart';
import 'package:pet_care/widgets/app_text.dart';

class CustomerPage extends GetView<CustomerController> {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khách hàng'),),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Obx(() => ListView.builder(
          itemCount: controller.customers.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                onTap: () async {
                  await controller.goDetailCustomers(controller.customers[index]);
                },
                title: AppText(text: controller.customers[index].name),
                subtitle: AppText(text: controller.customers[index].phone),
                trailing: AppText(text: '${controller.customers[index].times}', textAlign: TextAlign.end,),
              ),
            );
          },
        )),
      ),
    );
  }
}
