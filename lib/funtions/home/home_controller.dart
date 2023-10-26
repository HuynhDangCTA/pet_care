import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/customer/customer_page.dart';
import 'package:pet_care/funtions/dashboard/dashboard_page.dart';
import 'package:pet_care/funtions/invoice/invoice_page.dart';
import 'package:pet_care/funtions/product_manager/product_for_customer/product_for_customer_page.dart';
import 'package:pet_care/funtions/product_manager/product_page.dart';
import 'package:pet_care/funtions/staff_manager/staff_page.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  static HomeController get instants => Get.find();

  RxInt currentPage = 1.obs;
  RxBool isAdmin = false.obs;
  late SharedPreferences sharedPref;
  UserRequest? userCurrent;

  List pages = [
    const DashBoardPage(),
    const StaffPage(),
    const ProductPage(),
    const InvoicePage(),
    const CustomerPage(),
  ];

  List pagesStaff = [
    const ProductPage(),
    const InvoicePage(),
    const CustomerPage(),
  ];

  List pagesCustomer = [
    const ProductForCustomerPage(),
    Container(),
    Container()
  ];

  @override
  void onInit() async {
    sharedPref = await SharedPreferences.getInstance();
    super.onInit();
    String? userString = sharedPref.getString(Constants.users);
    debugPrint(userString);
    UserRequest user = UserRequest.fromMap(json.decode(userString!));
    userCurrent = user;
    if (user.type == Constants.typeStaff) {
      titles = titlesStaff;
      isAdmin.value = false;
    } else {
      isAdmin.value = true;
    }
  }

  List titles = ['Tổng quan', 'Nhân viên', 'Sản phẩm', 'Hóa đơn', 'Khách hàng'];
  List titleCustomer = ['Sản phẩm', 'Dịch vụ', 'Cá nhân'];
  List titlesStaff = ['Sản phẩm', 'Hóa đơn', 'Khách hàng'];

  void changePage(int index) {
    currentPage.value = index;
  }

  void logout() async {
    sharedPref.remove(Constants.users);
    Get.offAndToNamed(RoutesConst.login);
  }

  @override
  void onClose() {
    bool? isSave = sharedPref.getBool(Constants.saveUser);
    if (isSave == null || !isSave) {
      sharedPref.remove(Constants.users);
      sharedPref.remove(Constants.saveUser);
    }
    super.onClose();
  }
}
