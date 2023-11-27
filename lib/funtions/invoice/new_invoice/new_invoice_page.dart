import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/core/payment_methods_charactor.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/search_field.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class NewInvoicePage extends GetView<NewInvoiceController> {
  const NewInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var cardCustomer = Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'Thông tin khách hàng',
                  isBold: true,
                  color: MyColors.primaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    controller.newCustomer();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: MyColors.primaryColor,
                      ),
                      AppText(
                        text: 'Thêm mới',
                        color: MyColors.primaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SearchField(
              text: 'Tìm kiếm khách hàng',
              onChange: (value) {
                controller.searchCustomer(value);
              },
            ),
            Obx(() => (controller.customerFilter.isNotEmpty)
                ? Container(
                    width: size.width,
                    constraints: const BoxConstraints(
                      minHeight: 50,
                      maxHeight: 300,
                    ),
                    child: ListView.builder(
                      itemCount: controller.customerFilter.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            controller.pickCustomer(index);
                          },
                          title: Text(controller.customerFilter[index].name),
                          subtitle:
                              Text(controller.customerFilter[index].phone),
                          trailing: Text(controller.customerFilter[index].times
                              .toString()),
                        );
                      },
                    ),
                  )
                : const SizedBox(
                    height: 10,
                  )),
            Obx(() => (controller.selectedCustomer.value != null)
                ? Card(
                    child: ListTile(
                      title: AppText(
                          text: controller.selectedCustomer.value!.name),
                      subtitle: Text(controller.selectedCustomer.value!.phone),
                    ),
                  )
                : Container())
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'Thông tin sản phẩm',
                  isBold: true,
                  color: MyColors.primaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    controller.addProduct();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: MyColors.primaryColor,
                      ),
                      AppText(
                        text: 'Thêm mới',
                        color: MyColors.primaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
                width: size.width,
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                child: Obx(() => (controller.selectedProduct.isNotEmpty)
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.selectedProduct.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                controller.inputAmount(
                                    controller.selectedProduct[index]);
                              },
                              title: AppText(
                                text: controller.selectedProduct[index].name!,
                              ),
                              leading: AppText(
                                text:
                                    controller.amountProduct[index].toString(),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline_outlined),
                                onPressed: () {
                                  controller.selectedProduct.removeAt(index);
                                  controller.amountProduct.removeAt(index);
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : const AppText(text: 'Chưa có sản phẩm')))
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'Thông tin dịch vụ',
                  isBold: true,
                  color: MyColors.primaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    controller.addService();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: MyColors.primaryColor,
                      ),
                      AppText(
                        text: 'Thêm mới',
                        color: MyColors.primaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
                width: size.width,
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                child: Obx(() => (controller.selectedServices.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.selectedServices.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {},
                              title: AppText(
                                text: controller.selectedServices[index].name!,
                              ),
                              leading: AppText(
                                text:
                                    controller.amountService[index].toString(),
                              ),
                              subtitle: Text(
                                  controller.optionsService[index].toString()),
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
                    : const AppText(text: 'Chưa có dịch vụ')))
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
                    controller: controller.productDiscountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      FilteringTextInputFormatter.deny(RegExp(r'^[0-9]{4,}')),
                    ],
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
                    controller: controller.serviceDiscountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      FilteringTextInputFormatter.deny(RegExp(r'^[0-9]{4,}')),
                    ],
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

    var cardTotal = Obx(() => Card(
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
                (controller.selectedProduct.isNotEmpty)
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child: AppText(text: 'Tổng tiền sản phẩm:')),
                              Expanded(
                                  child: AppText(
                                textAlign: TextAlign.end,
                                text: NumberUtil.formatCurrency(
                                    controller.calculationProducts()),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : Container(),
                (controller.selectedServices.isNotEmpty)
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child: AppText(text: 'Tổng tiền dịch vụ:')),
                              Expanded(
                                  child: AppText(
                                textAlign: TextAlign.end,
                                text: NumberUtil.formatCurrency(
                                    controller.calculationService()),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : Container(),
                (controller.selectedProduct.isNotEmpty)
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child: AppText(text: 'Tổng giảm sản phẩm:')),
                              Expanded(
                                  child: AppText(
                                textAlign: TextAlign.end,
                                text: NumberUtil.formatCurrency(
                                    controller.calculationDiscountProduct()),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    : Container(),
                (controller.selectedServices.isNotEmpty)
                    ? Row(
                        children: [
                          const Expanded(
                              child: AppText(text: 'Tổng giảm dịch vụ:')),
                          Expanded(
                              child: AppText(
                            textAlign: TextAlign.end,
                            text: NumberUtil.formatCurrency(
                                controller.calculationDiscountService()),
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
                      text: NumberUtil.formatCurrency(
                          controller.calculationTotal()),
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
                      text: NumberUtil.formatCurrency(
                          controller.calculationCash()),
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
                          controller.calculationChangeDue()),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ));

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
                Obx(() => Expanded(
                      child: RadioListTile(
                        value: PaymentMethods.transfer,
                        groupValue: controller.paymentMethods.value,
                        onChanged: (value) {
                          controller.changePayment(value!);
                        },
                        title: const Text('Chuyển khoản'),
                      ),
                    )),
                Obx(() => Expanded(
                      child: RadioListTile(
                        value: PaymentMethods.cash,
                        groupValue: controller.paymentMethods.value,
                        onChanged: (value) {
                          controller.changePayment(value!);
                        },
                        title: const Text('Tiền mặt'),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => (controller.paymentMethods.value == PaymentMethods.cash)
                  ? Row(
                      children: [
                        const Expanded(child: AppText(text: 'Tiền khách đưa')),
                        Expanded(
                            child: MyTextFormField(
                          controller: controller.paymentController,
                          label: '',
                          keyboardType: TextInputType.number,
                          isCurrency: true,
                        ))
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tạo hóa đơn'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
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
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        if (controller.invoice == null) {
                          controller.saveInvoice();
                        } else {
                          controller.updateInvoice();
                        }
                      },
                      text: 'Lưu',
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        DialogUtil.showSnackBar('Chức năng đang phát triển');
                      },
                      text: 'In',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
