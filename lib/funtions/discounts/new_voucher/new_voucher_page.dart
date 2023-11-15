import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/discounts/new_voucher/new_voucher_controller.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/date_picker.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class NewVoucherPage extends GetView<NewVoucherController> {
  const NewVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo mã voucher'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              MyTextFormField(
                label: 'Tên Voucher',
                controller: controller.nameController,
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextFormField(
                label: 'Mã Voucher',
                controller: controller.codeController,
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextFormField(
                label: 'Phần trăm giảm',
                keyboardType: TextInputType.number,
                controller: controller.discountController,
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextFormField(
                label: 'Số lượng',
                keyboardType: TextInputType.number,
                controller: controller.amountController,
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextFormField(
                label: 'Điều kiện giảm giá',
                keyboardType: TextInputType.number,
                isCurrency: true,
                controller: controller.conditionController,
              ),
              const SizedBox(
                height: 5,
              ),
              const AppText(
                text: '(Tổng hóa đơn lớn hơn bao nhiêu)',
                size: 12,
              ),
              const SizedBox(
                height: 15,
              ),
              DatePicker(
                hintText: 'Ngày bắt đầu',
                selectedDate: controller.fromDate,
                onChange: (value) {
                  controller.fromDate = value;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              DatePicker(
                hintText: 'Ngày kết thúc',
                selectedDate: controller.toDate,
                onChange: (value) {
                  controller.toDate = value;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppButton(
                onPressed: () async {
                  await controller.newVoucher();
                },
                text: 'Tạo',
                isShadow: false,
                isResponsive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
