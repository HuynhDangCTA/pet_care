import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/order_manager/order_manager_controller.dart';
import 'package:pet_care/funtions/order_manager/order_status.dart';
import 'package:pet_care/model/order_model.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';

class OrderDetailPage extends GetView<OrderManagerController> {
  final OrderModel order = Get.arguments;

  OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget personalAddress = Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.primaryColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: controller.user!.name!,
            isBold: true,
          ),
          const SizedBox(
            height: 3,
          ),
          AppText(text: controller.user!.phoneNumber!),
          const SizedBox(
            height: 3,
          ),
          AppText(
            text: controller.user!.address!,
            maxLines: 3,
          ),
        ],
      ),
    );

    Widget shopAddress = Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: MyColors.primaryColor)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Tiệm nhà Chuột',
            isBold: true,
          ),
          SizedBox(
            height: 3,
          ),
          AppText(text: '0773850202'),
          SizedBox(
            height: 3,
          ),
          AppText(
            text:
                'Số 108/42 đường 30/4, phường An Phú, quận Ninh Kiều, TP. Cần Thơ',
            maxLines: 3,
          ),
        ],
      ),
    );

    Widget cardAddress = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Địa chỉ nhận hàng',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            AppText(text: order.address ?? ''),
            (order.address == 'Nhà') ? personalAddress : shopAddress
          ],
        ),
      ),
    );

    Widget cardProduct = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Sản phẩm',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Product product = order.product![index];
                return Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(product.image!))),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: product.name ?? '',
                                maxLines: 2,
                              ),
                              AppText(
                                  text: NumberUtil.formatCurrency(
                                      product.price! *
                                          (100 - product.discount!) /
                                          100))
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        right: 8,
                        child: AppText(
                          text: 'x${product.sold}',
                          color: Colors.grey,
                        ))
                  ],
                );
              },
              itemCount: order.product!.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            )
          ],
        ),
      ),
    );

    // Widget cardVoucher = Card(
    //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const AppText(
    //           text: 'Voucher',
    //           size: 16,
    //           isBold: true,
    //           color: MyColors.primaryColor,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //           },
    //           child: Container(
    //             width: Get.width,
    //             height: 60,
    //             padding: const EdgeInsets.all(5),
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(10),
    //                 border: Border.all(color: Colors.grey)),
    //             child: Obx(() => (controller.voucher.value == null)
    //                 ? Image.asset('images/add_voucher.png')
    //                 : Center(
    //                     child: AppText(
    //                       text:
    //                           '${controller.voucher.value!.code!} - Giảm ${controller.voucher.value!.discount!}%',
    //                     ),
    //                   )),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    List<String> status = OrderStatusConst.getList(order.status!);

    Widget steper(OrderModel order) => Stepper(
        physics: const NeverScrollableScrollPhysics(),
        controlsBuilder: (context, details) {
          return Container();
        },
        currentStep: status.length - 1,
        stepIconBuilder: (stepIndex, stepState) {
          if (stepState == StepState.editing) {
            return const Icon(
              Icons.fire_truck,
              size: 14,
              color: Colors.white,
            );
          }
        },
        steps: status
            .map((e) => Step(
                  isActive: true,
                  title: AppText(
                    text: e,
                    color: (e == OrderStatusConst.huyDon ||
                            e == OrderStatusConst.giaoHangThatBai)
                        ? Colors.red
                        : (e == OrderStatusConst.giaoHangThanhCong)
                            ? Colors.green
                            : Colors.black,
                  ),
                  state: (e == OrderStatusConst.huyDon ||
                          e == OrderStatusConst.giaoHangThanhCong ||
                          e == OrderStatusConst.giaoHangThatBai ||
                          e != status.last)
                      ? StepState.complete
                      : StepState.editing,
                  content: Container(),
                ))
            .toList());

    Widget cardStepper = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Trạng thái đơn hàng',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            steper(order),
          ],
        ),
      ),
    );

    Widget cardMoney = Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thanh toán',
              size: 16,
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Tổng tiên')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(order.totalMoney),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Giảm giá')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(order.discountMoney),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Voucher')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(order.voucherMoney),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Phí ship')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(order.shipFee),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Expanded(child: AppText(text: 'Thanh toán')),
                Expanded(
                    child: AppText(
                  text: NumberUtil.formatCurrency(order.payMoney),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardAddress,
            cardStepper,
            cardProduct,
            // cardVoucher,

            cardMoney,
            (order.status == OrderStatusConst.choXacNhan)
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: AppButton(
                      onPressed: () async {},
                      backgroundColor: Colors.red,
                      isResponsive: true,
                      isShadow: false,
                      text: 'Hủy đơn',
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
