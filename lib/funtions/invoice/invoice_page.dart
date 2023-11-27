import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/invoice/invoice_controller.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';
import 'package:pet_care/widgets/empty_data.dart';

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CardControl(
                      image: 'images/invoice.png',
                      text: 'Tạo hóa đơn',
                      onTap: () {
                        controller.goNewInvoice();
                      }),
                  CardControl(
                    image: 'images/ic_customer.png',
                    text: 'Khách hàng',
                    onTap: () {
                      controller.goCustomerPage();
                    },
                  ),
                  CardControl(
                    image: 'images/order.png',
                    text: 'Đơn hàng',
                    onTap: () {
                      controller.goOrderPage();
                    },
                  ),
                ],
              ),
            ),
            Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                            text:
                                'Hóa đơn hôm nay: ${controller.totalInvoice.value}'),
                        AppText(
                            text:
                                'Tổng: ${NumberUtil.formatCurrency(controller.totalMoney.value)}')
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Obx(() => (controller.invoices.isNotEmpty)
                    ? ListView.builder(
                        itemCount: controller.invoices.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await controller.goDetail(controller.invoices[index]);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: AppText(
                                          text: DateTimeUtil.formatTime(
                                              controller
                                                  .invoices[index].createdAt),
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
                                            text: controller
                                                .invoices[index].status,
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
                                        const Expanded(
                                            child: AppText(text: 'Người tạo')),
                                        Expanded(
                                            child: AppText(
                                          text: controller
                                              .invoices[index].staffName,
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Expanded(
                                            child: AppText(text: 'Khách hing')),
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
                                        const Expanded(
                                            child: AppText(text: 'Tổng tiền')),
                                        Expanded(
                                            child: AppText(
                                          text: NumberUtil.formatCurrency(
                                              controller
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
                                        // Expanded(
                                        //   child: AppButton(
                                        //     onPressed: () {
                                        //       Get.toNamed(
                                        //           RoutesConst.newInvoice,
                                        //           arguments: controller
                                        //               .invoices[index]);
                                        //     },
                                        //     text: 'Chỉnh sửa',
                                        //     height: 48,
                                        //     isShadow: false,
                                        //   ),
                                        // ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        (controller.invoices[index].status ==
                                                'Đã lưu')
                                            ? AppButton(
                                                onPressed: () {
                                                  DialogUtil.showSnackBar('Chức nâng đang phát triển');
                                                },
                                                text: 'In hóa đơn',
                                                height: 48,
                                                width: 150,
                                                isShadow: false,
                                              )
                                            : Container()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: EmptyDataWidget())))
          ],
        ),
      ),
    );
  }
}
