import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/order_manager/order_manager_controller.dart';
import 'package:pet_care/funtions/order_manager/order_status.dart';
import 'package:pet_care/model/order_model.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:pet_care/widgets/stepper.dart';

class OrderManagerPage extends GetView<OrderManagerController> {
  const OrderManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget waitOrder = Obx(() => (controller.waitOrders.isNotEmpty)
        ? ListView.builder(
            itemCount: controller.waitOrders.length,
            itemBuilder: (context, index) {
              OrderModel order = controller.waitOrders[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConst.orderDetail, arguments: order);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: AppText(
                              text: order.orderBy!.name ?? '',
                              isBold: true,
                            )),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  color:
                                      OrderStatusConst.getColor(order.status!)),
                              child: AppText(
                                text: order.status ?? '',
                                color: Colors.white,
                                isBold: true,
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          text: order.orderBy!.phoneNumber ?? '',
                          isBold: true,
                        ),
                        (order.address! == 'Nhà')
                            ? AppText(
                                text: order.orderBy!.address ?? '',
                                isBold: true,
                              )
                            : const AppText(
                                text: 'Nhận hàng tại shop',
                                isBold: true,
                              ),
                        AppText(
                          text: '${order.product!.length} sản phẩm',
                          isBold: true,
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/product_demo.jpg'))),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: order.product!.first.name ?? '',
                                      size: 14,
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: NumberUtil.formatCurrency(
                                              order.product!.first.price),
                                          size: 14,
                                        ),
                                        AppText(
                                          text: 'x${order.product!.first.sold}',
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Center(
                            child: Icon(
                          Icons.more_horiz_rounded,
                          color: MyColors.textColor,
                        )),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                                child: AppText(
                              text: 'Thành tiền',
                              isBold: true,
                            )),
                            Expanded(
                                child: AppText(
                              text: NumberUtil.formatCurrency(order.payMoney),
                              textAlign: TextAlign.end,
                            ))
                          ],
                        ),
                        const Divider(),
                        (order.status == OrderStatusConst.choXacNhan)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppButton(
                                    onPressed: () async {
                                      await controller.cancelOrder(order);
                                    },
                                    text: 'Hủy đơn',
                                    width: 150,
                                    height: 40,
                                    backgroundColor: Colors.grey,
                                    isShadow: false,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AppButton(
                                    onPressed: () async {
                                      await controller.acceptOrder(order);
                                    },
                                    text: 'Xác nhận',
                                    width: 150,
                                    height: 40,
                                    backgroundColor: Colors.red,
                                    isShadow: false,
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(
            child: EmptyDataWidget(),
          ));

    Widget unFinish = Obx(() => (controller.unFinishOrders.isNotEmpty)
        ? ListView.builder(
            itemCount: controller.unFinishOrders.length,
            itemBuilder: (context, index) {
              OrderModel order = controller.unFinishOrders[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConst.orderDetail, arguments: order);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: AppText(
                              text: order.orderBy!.name ?? '',
                              isBold: true,
                            )),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  color:
                                      OrderStatusConst.getColor(order.status!)),
                              child: AppText(
                                text: order.status ?? '',
                                color: Colors.white,
                                isBold: true,
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          text: order.orderBy!.phoneNumber ?? '',
                          isBold: true,
                        ),
                        (order.address! == 'Nhà')
                            ? AppText(
                                text: order.orderBy!.address ?? '',
                                isBold: true,
                              )
                            : const AppText(
                                text: 'Nhận hàng tại shop',
                                isBold: true,
                              ),
                        AppText(
                          text: '${order.product!.length} sản phẩm',
                          isBold: true,
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/product_demo.jpg'))),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: order.product!.first.name ?? '',
                                      size: 14,
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: NumberUtil.formatCurrency(
                                              order.product!.first.price),
                                          size: 14,
                                        ),
                                        AppText(
                                          text: 'x${order.product!.first.sold}',
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Center(
                            child: Icon(
                          Icons.more_horiz_rounded,
                          color: MyColors.textColor,
                        )),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                                child: AppText(
                              text: 'Thành tiền',
                              isBold: true,
                            )),
                            Expanded(
                                child: AppText(
                              text: NumberUtil.formatCurrency(order.payMoney),
                              textAlign: TextAlign.end,
                            ))
                          ],
                        ),
                        const Divider(),
                        (order.status == OrderStatusConst.dangChuanBiHang)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AppButton(
                                    onPressed: () async {
                                      await controller.shipOrder(order);
                                    },
                                    text: 'Giao hàng',
                                    width: 150,
                                    height: 40,
                                    backgroundColor: MyColors.primaryColor,
                                    isShadow: false,
                                  ),
                                ],
                              )
                            : (order.status == OrderStatusConst.dangGiaoHang)
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AppButton(
                                        onPressed: () async {
                                          await controller.failureOrder(order);
                                        },
                                        text: 'Thất bại',
                                        width: 150,
                                        height: 40,
                                        backgroundColor: Colors.red,
                                        isShadow: false,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AppButton(
                                        onPressed: () async {
                                          await controller.doneOrder(order);
                                        },
                                        text: 'Hoàn thành',
                                        width: 150,
                                        height: 40,
                                        backgroundColor: Colors.green,
                                        isShadow: false,
                                      ),
                                    ],
                                  )
                                : Container()
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : const Center(
            child: EmptyDataWidget(),
          ));

    Widget finish = Obx(() => (controller.finishOrders.isNotEmpty)
        ? ListView.builder(
            itemCount: controller.finishOrders.length,
            itemBuilder: (context, index) {
              OrderModel order = controller.finishOrders[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(RoutesConst.orderDetail, arguments: order);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: AppText(
                              text: order.orderBy!.name ?? '',
                              isBold: true,
                            )),
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ),
                                  color:
                                      OrderStatusConst.getColor(order.status!)),
                              child: AppText(
                                text: order.status ?? '',
                                color: Colors.white,
                                isBold: true,
                              ),
                            ),
                          ],
                        ),
                        AppText(
                          text: order.orderBy!.phoneNumber ?? '',
                          isBold: true,
                        ),
                        (order.address! == 'Nhà')
                            ? AppText(
                                text: order.orderBy!.address ?? '',
                                isBold: true,
                              )
                            : const AppText(
                                text: 'Nhận hàng tại shop',
                                isBold: true,
                              ),
                        AppText(
                          text: '${order.product!.length} sản phẩm',
                          isBold: true,
                        ),
                        const Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/product_demo.jpg'))),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: order.product!.first.name ?? '',
                                      size: 14,
                                      maxLines: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: NumberUtil.formatCurrency(
                                              order.product!.first.price),
                                          size: 14,
                                        ),
                                        AppText(
                                          text: 'x${order.product!.first.sold}',
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Center(
                            child: Icon(
                          Icons.more_horiz_rounded,
                          color: MyColors.textColor,
                        )),
                        const Divider(),
                        Row(
                          children: [
                            const Expanded(
                                child: AppText(
                              text: 'Thành tiền',
                              isBold: true,
                            )),
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
                ),
              );
            },
          )
        : const Center(
            child: EmptyDataWidget(),
          ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => MyStepper(
                    steps: [
                      MyStep(
                          title: 'Chờ xác nhận',
                          isActive: (controller.currentStep.value == 0)),
                      MyStep(
                          title: 'Chưa hoàn thành',
                          isActive: (controller.currentStep.value == 1)),
                      MyStep(
                          title: 'Hoàn thành',
                          isActive: (controller.currentStep.value == 2)),
                    ],
                    onStepTapped: (value) {
                      controller.changePage(value);
                    })),
            Obx(() {
              if (controller.currentStep.value == 0) {
                return Expanded(child: waitOrder);
              } else if (controller.currentStep.value == 1) {
                return Expanded(child: unFinish);
              } else {
                return Expanded(child: finish);
              }
            })
          ],
        ),
      ),
    );
  }
}
