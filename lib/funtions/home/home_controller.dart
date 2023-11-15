import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/customer/customer_page.dart';
import 'package:pet_care/funtions/dashboard/dashboard_page.dart';
import 'package:pet_care/funtions/discounts/discount_page.dart';
import 'package:pet_care/funtions/invoice/invoice_page.dart';
import 'package:pet_care/funtions/product_manager/product_page.dart';
import 'package:pet_care/funtions/staff_manager/staff_page.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/services/fcm_service.dart';
import 'package:pet_care/util/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static HomeController get instants => Get.find();

  RxInt currentPage = 1.obs;
  RxBool isAdmin = false.obs;
  UserResponse? userCurrent;

  List pages = [
    const DashBoardPage(),
    const StaffPage(),
    const ProductPage(),
    const InvoicePage(),
    const DiscountPage(),
  ];

  List pagesStaff = [
    const ProductPage(),
    const InvoicePage(),
    const DiscountPage(),
  ];



  @override
  void onInit() async {
    super.onInit();
    UserResponse? user = await SharedPref.getUser();
    debugPrint('user local home: ${user!.toMap().toString()}');
    userCurrent = user;
    await FCMService.setUpFCM(userCurrent!.id!);
    if (user!.type == Constants.typeStaff) {
      titles = titlesStaff;
      isAdmin.value = false;
    } else {
      isAdmin.value = true;
    }
  }

  List titles = ['Tổng quan', 'Nhân viên', 'Sản phẩm', 'Hóa đơn', 'Khuyến mãi'];
  List titleCustomer = ['Sản phẩm', 'Dịch vụ', 'Cá nhân'];
  List titlesStaff = ['Sản phẩm', 'Hóa đơn', 'Khách hàng'];

  void changePage(int index) {
    currentPage.value = index;
  }

  void logout() async {
    SharedPref.removeUser();
    Get.offAndToNamed(RoutesConst.login);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
