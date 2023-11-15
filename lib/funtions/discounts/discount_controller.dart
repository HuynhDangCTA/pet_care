import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/model/discount.dart';
import 'package:pet_care/model/voucher.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';

class DiscountController extends GetxController {
  RxList<Discount> discounts = <Discount>[].obs;
  RxList<Voucher> vouchers = <Voucher>[].obs;
  RxInt currentStep = 0.obs;
  final DateTime now = DateTime.now();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    DialogUtil.showLoading();
    await getAllDiscount();
    listenVoucher();
    DialogUtil.hideLoading();
    super.onReady();
  }

  void changeScreen(value) {
    currentStep.value = value;
  }

  Future getAllDiscount() async {
    await FirebaseHelper.getDiscount().then((value) {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          Discount discount =
              Discount.fromMap(doc.data() as Map<String, dynamic>);
          discount.id = doc.id;
          if (now.isAfter(discount.fromDate!) &&
              now.isBefore(discount.toDate!)) {
            discount.status = 'Đang chạy';
          } else {
            discount.status = 'Dừng';
          }
          discounts.add(discount);
        }
      }
    });
  }

  void listenVoucher() {
    FirebaseHelper.listenVoucher(addEvent: (voucher) {
      vouchers.add(voucher);
      vouchers.refresh();
    }, modifyEvent: (voucher) {
      for (int i = 0; i < vouchers.length; i++) {
        if (vouchers[i].id == voucher.id) {
          vouchers[i] = voucher;
          break;
        }
      }
      vouchers.refresh();
    });
  }
}
