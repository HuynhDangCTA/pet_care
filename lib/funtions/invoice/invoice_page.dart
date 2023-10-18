import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/invoice/invoice_controller.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';

class InvoicePage extends GetView<InvoiceController> {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardControl(
                image: 'images/invoice.png',
                text: 'Tạo hóa đơn',
                onTap: () {
                  controller.goNewInvoice();
                }),
            Obx(() => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: 'Hóa đơn hôm nay: ${controller.totalInvoice.value}'),
                    AppText(text: 'Tổng: ${NumberUtil.formatCurrency(controller.totalMoney.value)}')
                  ],
                ),
              ),
            )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Obx(() => ListView.builder(
                      itemCount: controller.invoices.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: AppText(
                                      text: DateTimeUtil.formatTime(
                                          controller.invoices[index].createdAt),
                                      color: MyColors.primaryColor,
                                      isBold: true,
                                    )),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: MyColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child: AppText(
                                        text: controller.invoices[index].status,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: AppText(text: 'Người tạo')),
                                    Expanded(
                                        child: AppText(
                                      text:
                                          controller.invoices[index].staffName,
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: AppText(text: 'Khách hàng')),
                                    Expanded(
                                        child: AppText(
                                      text: controller
                                          .invoices[index].customerName,
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(child: AppText(text: 'Tổng tiền')),
                                    Expanded(
                                        child: AppText(
                                      text: NumberUtil.formatCurrency(controller
                                          .invoices[index].totalMoney),
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        onPressed: () {},
                                        text: 'Chỉnh sửa',
                                        height: 48,
                                        isShadow: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: AppButton(
                                        onPressed: () {},
                                        text: 'In',
                                        height: 48,
                                        isShadow: false,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
