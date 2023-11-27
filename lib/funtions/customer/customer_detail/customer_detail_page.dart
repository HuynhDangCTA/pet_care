import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/order_manager/order_status.dart';
import 'package:pet_care/model/customer.dart';
import 'package:pet_care/model/order.dart';
import 'package:pet_care/model/order_model.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/empty_data.dart';

import '../../../core/colors.dart';
import '../../../util/number_util.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer customer;

  const CustomerDetailPage({super.key, required this.customer});

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
              text: 'Thông tin khách hàng',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(text: 'Họ tên: ${customer.name}'),
            AppText(text: 'Số điện thoại: ${customer.phone ?? ''}'),
            AppText(text: 'Số lần sử dụng dịch vụ: ${customer.times ?? 0}')
          ],
        ),
      ),
    );

    Widget orders = (customer.orders != null && customer.orders!.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customer.orders!.length,
            itemBuilder: (context, index) {
              OrderModel order = customer.orders![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: GestureDetector(
                  onTap: () {},
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
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Container();

    var cardOrder = Card(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Thông tin đơn hàng',
              isBold: true,
              color: MyColors.primaryColor,
            ),
            const SizedBox(
              height: 10,
            ),
            (customer.idUser == null)
                ? const Center(
                    child: AppText(text: 'Khách hàng chưa tạo tài khoản'),
                  )
                : (customer.orders == null || customer.orders!.isEmpty)
                    ? const EmptyDataWidget()
                    : orders
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết khách hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              cardStaff,
              const SizedBox(
                height: 10,
              ),
              cardOrder
            ],
          ),
        ),
      ),
    );
  }
}
