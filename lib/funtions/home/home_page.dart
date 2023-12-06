import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/home/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(onPressed: () {
              controller.logout();
          }, icon: const Icon(Icons.logout))
        ],
        title: Obx(
          () => Text(controller.titles[controller.currentPage.value]),
        ),
      ),
      body: Obx(() => (controller.isAdmin.value)
          ? controller.pages[controller.currentPage.value]
          : controller.pagesStaff[controller.currentPage.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 10,
            showUnselectedLabels: true,
            selectedItemColor: MyColors.primaryColor,
            unselectedItemColor: MyColors.textColor,
            currentIndex: controller.currentPage.value,
            onTap: (value) {
              controller.changePage(value);
            },
            items: (controller.isAdmin.value)
                ? [
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.dashboard), label: 'Tổng quan'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: 'Nhân viên'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.paid_rounded), label: 'Sản phẩm'),
                    const BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.moneyBill),
                        label: 'Hóa đơn'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.discount), label: 'Khuyến mãi'),
                  ]
                : [
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.paid_rounded), label: 'Sản phẩm'),
                    const BottomNavigationBarItem(
                        icon: Icon(FontAwesomeIcons.moneyBill),
                        label: 'Hóa đơn'),
                    const BottomNavigationBarItem(
                        icon: Icon(Icons.discount), label: 'Khuyến mãi'),
                  ],
          )),
    );
  }
}
