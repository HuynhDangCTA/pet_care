import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/home/home_controller.dart';

import '../../core/colors.dart';

class HomeCustomerPage extends GetView<HomeController> {
  const HomeCustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        actions: [
          IconButton(onPressed: () {
            controller.logout();
          }, icon: Icon(Icons.logout))
        ],
        title: Obx(
              () => Text(controller.titleCustomer[controller.currentPage.value]),
        ),
      ),
      body: Obx(() => controller.pagesCustomer[controller.currentPage.value]),
      bottomNavigationBar: Obx(() =>
          BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 10,
              showUnselectedLabels: true,
              selectedItemColor: MyColors.primaryColor,
              unselectedItemColor: MyColors.textColor,
              currentIndex: controller.currentPage.value,
              onTap: (value) {
                controller.changePage(value);
              },
              items:
              const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.paid_rounded), label: 'Sản phẩm'),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.servicestack),
                    label: 'Dịch vụ'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.people_alt), label: 'Cá nhân'),
              ]
          )),
    );
  }
}
