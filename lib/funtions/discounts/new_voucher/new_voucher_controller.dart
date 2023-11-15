import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pet_care/model/voucher.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/number_util.dart';

class NewVoucherController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController conditionController = TextEditingController();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 1));

  Future newVoucher() async {
    String name = nameController.text;
    String code = codeController.text;
    String discount = discountController.text;
    String amount = amountController.text;
    String condition = conditionController.text;

    if (name.isEmpty ||
        code.isEmpty ||
        discount.isEmpty ||
        amount.isEmpty ||
        condition.isEmpty) {
      DialogUtil.showSnackBar('Hãy nhập đầy đủ thông tin');
      return;
    }
    DialogUtil.showLoading();
    Voucher voucher = Voucher(
      name: name,
      code: code,
      discount: int.parse(discount),
      amount: int.parse(amount),
      condition: NumberUtil.parseCurrency(condition).toInt(),
      toDate: toDate,
      fromDate: fromDate,
    );

    await FirebaseHelper.newVoucher(voucher).then((value) {
      DialogUtil.hideLoading();
      DialogUtil.showSnackBar('Thêm thành công');
      nameController.clear();
      codeController.clear();
      discountController.clear();
      amountController.clear();
      conditionController.clear();
    });
  }
}
