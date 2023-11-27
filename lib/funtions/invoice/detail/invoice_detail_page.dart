import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/payment_methods_charactor.dart';
import 'package:pet_care/model/invoice.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';

import '../../../core/colors.dart';

class InvoiceDetailPage extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailPage({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    var cardStaff = Card(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thông tin nhân viên',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(text: 'Nhân viên: ${invoice.staffName}'),
            AppText(text: 'Số điện thoại: ${invoice.staff!.phoneNumber ?? ''}'),
            AppText(text: 'Ngày tạo: ${DateTimeUtil.formatTime(invoice.createdAt)}')
          ],
        ),
      ),
    );

    var cardCustomer = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thông tin khách hàng',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                title: AppText(text: invoice.customerName),
                subtitle: Text(invoice.customer!.phone ?? ''),
                leading: AppText(text: invoice.customer!.times.toString()),
              ),
            )
          ],
        ),
      ),
    );

    var cardProduct = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thông tin sản phẩm',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            Container(
                width: Get.width,
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                child: (invoice.products != null &&
                        invoice.products!.isNotEmpty)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: invoice.products!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: AppText(
                                text: invoice.products![index].name!,
                              ),
                              leading: AppText(
                                text:
                                    invoice.products![index].amount.toString(),
                              ),
                            ),
                          );
                        },
                      )
                    : const AppText(text: 'Không có sản phẩm'))
          ],
        ),
      ),
    );

    var cardService = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thông tin dịch vụ',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            Container(
                width: Get.width,
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                child: (invoice.services != null &&
                        invoice.services!.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: invoice.services!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: AppText(
                                text: invoice.services![index].name!,
                              ),
                              leading: AppText(
                                text: invoice
                                    .services![index]
                                    .options![
                                        invoice.services![index].selectedOption]
                                    .toString(),
                              ),
                              subtitle: Text(invoice
                                  .services![index].selectedOption
                                  .toString()),
                            ),
                          );
                        },
                      )
                    : const AppText(text: 'Không có dịch vụ'))
          ],
        ),
      ),
    );

    var cardDiscount = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Thông tin khuyến mãi',
                  isBold: true,
                  color: MyColors.primaryColor,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Giảm giá sản phẩm:')),
                Expanded(
                  child: TextFormField(
                    initialValue: invoice.discountProduct.toString(),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                        suffixText: '%', border: OutlineInputBorder()),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Giảm giá dịch vụ:')),
                Expanded(
                  child: TextFormField(
                    initialValue: invoice.discountService.toString(),
                    keyboardType: TextInputType.number,
                    enabled: false,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                        suffixText: '%', border: OutlineInputBorder()),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    int getTotalProduct() {
      int total = 0;
      for (var item in invoice.products!) {
        total += (item.amount! * item.price!);
      }
      return total;
    }

    int getTotalService() {
      int total = 0;
      for (var item in invoice.services!) {
        total += (int.parse(item.options![item.selectedOption]!.toString()) *
                item.days!)
            .round();
      }
      return total;
    }

    var cardTotal = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Thanh toán',
                  isBold: true,
                  color: MyColors.primaryColor,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            (invoice.products != null && invoice.products!.isNotEmpty)
                ? Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: AppText(text: 'Tổng tiền sản phẩm:')),
                          Expanded(
                              child: AppText(
                            textAlign: TextAlign.end,
                            text: NumberUtil.formatCurrency(getTotalProduct()),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(),
            (invoice.services != null && invoice.services!.isNotEmpty)
                ? Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: AppText(text: 'Tổng tiền dịch vụ:')),
                          Expanded(
                              child: AppText(
                            textAlign: TextAlign.end,
                            text: NumberUtil.formatCurrency(getTotalService()),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(),
            (invoice.products != null && invoice.products!.isNotEmpty)
                ? Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: AppText(text: 'Tổng giảm sản phẩm:')),
                          Expanded(
                              child: AppText(
                            textAlign: TextAlign.end,
                            text: NumberUtil.formatCurrency(getTotalProduct() *
                                invoice.discountProduct /
                                100),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Container(),
            (invoice.services != null && invoice.services!.isNotEmpty)
                ? Row(
                    children: [
                      const Expanded(
                          child: AppText(text: 'Tổng giảm dịch vụ:')),
                      Expanded(
                          child: AppText(
                        textAlign: TextAlign.end,
                        text: NumberUtil.formatCurrency(
                            getTotalService() * invoice.discountService / 100),
                      )),
                    ],
                  )
                : Container(),
            const Divider(color: MyColors.primaryColor, thickness: 1),
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Tổng:',
                  isBold: true,
                )),
                Expanded(
                    child: AppText(
                  isBold: true,
                  textAlign: TextAlign.end,
                  text: NumberUtil.formatCurrency(invoice.totalMoney),
                )),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Tiền khách đưa:',
                )),
                Expanded(
                    child: AppText(
                  textAlign: TextAlign.end,
                  text: NumberUtil.formatCurrency(invoice.paymentMoney),
                )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                    child: AppText(
                  text: 'Tiền thối lại',
                )),
                Expanded(
                    child: AppText(
                  textAlign: TextAlign.end,
                  text: NumberUtil.formatCurrency(
                      invoice.paymentMoney - invoice.totalMoney),
                )),
              ],
            ),
          ],
        ),
      ),
    );

    var cardMoneyCustomer = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Phương thức thanh toán',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: PaymentMethods.transfer,
                    groupValue: invoice.paymentMethod,
                    onChanged: (value) {},
                    title: const Text('Chuyển khoản'),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: PaymentMethods.cash,
                    groupValue: invoice.paymentMethod,
                    onChanged: (value) {},
                    title: const Text('Tiền mặt'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết hóa đơn'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              cardStaff,
              const SizedBox(
                height: 10,
              ),
              cardCustomer,
              const SizedBox(
                height: 10,
              ),
              cardProduct,
              const SizedBox(
                height: 10,
              ),
              cardService,
              const SizedBox(
                height: 10,
              ),
              cardDiscount,
              const SizedBox(
                height: 10,
              ),
              cardMoneyCustomer,
              const SizedBox(
                height: 10,
              ),
              cardTotal,
              const SizedBox(
                height: 10,
              ),
              (invoice.status == 'Đã lưu')
                  ? AppButton(
                      onPressed: () {
                        DialogUtil.showSnackBar('Chức năng đang phát triển');
                      },
                      isResponsive: true,
                      isShadow: false,
                      text: 'In hóa đơn',
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
