import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/widgets/service_card.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/search_field.dart';

class AddServicePage extends GetView<NewInvoiceController> {
  const AddServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm dịch vụ"),
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
                  child: Obx(() => (controller.selectedServices.isNotEmpty)
                      ? ListView.builder(
                          itemCount: controller.selectedServices.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  controller.inputService(
                                      controller.selectedServices[index]);
                                },
                                title: AppText(
                                  text:
                                      controller.selectedServices[index].name!,
                                ),
                                subtitle: Text(controller.optionsService[index]
                                    .toString()),
                                leading: Text(
                                    controller.amountService[index].toString()),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline_outlined),
                                  onPressed: () {
                                    controller.selectedServices.removeAt(index);
                                    controller.amountService.removeAt(index);
                                    controller.optionsService.removeAt(index);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const AppText(text: 'Chưa có dịch vụ')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SearchField(
              text: 'Tìm kiếm dịch vụ',
              onChange: (value) {
                controller.searchService(value);
              },
            ),
            Expanded(
              flex: 3,
              child: Obx(() => ListView.builder(
                    itemCount: controller.servicesFilter.length,
                    itemBuilder: (context, index) {
                      return ServiceCard(
                        service: controller.servicesFilter[index],
                        onPick: (service) {
                          controller.inputService(service);
                        },
                        onDeleted: (ServiceModel service) {},
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
