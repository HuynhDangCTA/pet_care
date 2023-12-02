import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/discounts/discount_controller.dart';
import 'package:pet_care/model/discount.dart';
import 'package:pet_care/model/voucher.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:pet_care/widgets/stepper.dart';

class DiscountPage extends GetView<DiscountController> {
  const DiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget discountWidget = Obx(() => (controller.discounts.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Discount discount = controller.discounts[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  text: discount.name ?? '',
                                  isBold: true,
                                  size: 18,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: (discount.status == 'Dừng')
                                        ? Colors.red
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: AppText(
                                  text: discount.status,
                                  color: Colors.white,
                                  isBold: true,
                                ),
                              )
                            ],
                          ),
                          (discount.isAllProduct!)
                              ? const Row(
                                  children: [
                                    AppText(text: 'Áp dụng: Tất cả sản phẩm'),
                                  ],
                                )
                              : Row(
                                  children: [
                                    AppText(
                                        text:
                                            'Áp dụng: ${discount.productId!.length} sản phẩm'),
                                  ],
                                ),
                          AppText(
                              text:
                                  'Từ ngày: ${DateTimeUtil.format(discount.fromDate!)}'),
                          AppText(
                              text:
                                  'Đến ngày: ${DateTimeUtil.format(discount.toDate!)}'),
                          AppText(text: 'Giảm giá: ${discount.discount}%')
                        ],
                      ),
                      Obx(() => (controller.isAdmin.value)
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () async {
                                    await controller.deleteDiscount(discount);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: MyColors.primaryColor,
                                  )))
                          : Container())
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.discounts.length,
          )
        : const Center(
            child: EmptyDataWidget(),
          ));

    Widget voucherWidget = Obx(() => (controller.vouchers.length > 0)
        ? ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Voucher voucher = controller.vouchers[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AppText(
                                  text: voucher.name ?? '',
                                  isBold: true,
                                  size: 18,
                                  color: MyColors.primaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: (voucher.used < voucher.amount!)
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: AppText(
                                  text: (voucher.used < voucher.amount!)
                                      ? 'Còn lại ${voucher.used}/${voucher.amount!}'
                                      : 'Hết mã',
                                  color: Colors.white,
                                  isBold: true,
                                ),
                              )
                            ],
                          ),
                          AppText(text: 'Mã: ${voucher.code}'),
                          AppText(
                              text:
                                  'Điều kiện: Hóa đơn >${NumberUtil.formatCurrency(voucher.condition)}'),
                          AppText(
                              text:
                                  'Từ ngày: ${DateTimeUtil.format(voucher.fromDate!)}'),
                          AppText(
                              text:
                                  'Đến ngày: ${DateTimeUtil.format(voucher.toDate!)}'),
                          AppText(text: 'Giảm giá: ${voucher.discount}%')
                        ],
                      ),
                      (controller.isAdmin.value)
                          ? Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  onPressed: () {
                                    controller.deleteVoucher(voucher.id!);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: MyColors.primaryColor,
                                  )))
                          : Container()
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.vouchers.length,
          )
        : const Center(
            child: EmptyDataWidget(),
          ));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => (controller.isAdmin.value)
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CardControl(
                          image: 'images/ic_discount.png',
                          text: 'Tạo khuyễn mãi',
                          onTap: () {
                            Get.toNamed(RoutesConst.newDiscount);
                          },
                        ),
                        CardControl(
                          image: 'images/ic_voucher.png',
                          text: 'Tạo Voucher',
                          onTap: () {
                            Get.toNamed(RoutesConst.newVoucher);
                          },
                        ),
                      ],
                    ),
                  )
                : Container()),
            const SizedBox(
              height: 10,
            ),
            Obx(() => MyStepper(
                    steps: [
                      MyStep(
                          title: 'Khuyến mãi',
                          isActive: (controller.currentStep.value == 0)),
                      MyStep(
                          title: 'Voucher',
                          isActive: (controller.currentStep.value == 1)),
                    ],
                    onStepTapped: (value) {
                      controller.changeScreen(value);
                    })),
            const SizedBox(
              height: 10,
            ),
            Obx(() => (controller.currentStep.value == 0)
                ? Expanded(child: discountWidget)
                : Expanded(child: voucherWidget)),
          ],
        ),
      ),
    );
  }
}
