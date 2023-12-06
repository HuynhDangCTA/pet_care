import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';

class ServiceDetailPage extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết dịch vụ'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(service.image!, width: Get.width),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: service.name ?? '',
                        color: MyColors.primaryColor,
                        size: 20,
                        isBold: true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(text: 'Dịch vụ dành cho: ' + (service.isCat ? 'Cún': 'Mèo')),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(text: 'Mô tả: ' + (service.decription ?? ''), maxLines: 1000,),
                  const SizedBox(
                    height: 20,
                  ),
                  const AppText(
                    text: 'Đơn giá',
                    isBold: true,
                  ),
                  Column(
                    children: List.generate(
                        service.options!.keys.toList().length, (index) {
                      return Row(
                        children: [
                          Expanded(
                              child: AppText(
                                  text: '* '+service.options!.keys.toList()[index])),
                          Expanded(
                            child: AppText(
                                textAlign: TextAlign.end,
                                text: NumberUtil.formatCurrency(
                                    service.options!.values.toList()[index])),
                          ),
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 40,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
