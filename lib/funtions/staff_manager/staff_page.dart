import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/widgets/card_staff.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:pet_care/widgets/loading.dart';

class StaffPage extends GetView<StaffController> {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            width: size.width,
            height: size.height,
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 40),
            child: Stack(
              children: [
                Obx(() => ListView.builder(
                      itemCount: controller.staffs.length,
                      itemBuilder: (context, index) {
                        return CardStaff(
                          index: index,
                          staff: controller.staffs[index],
                          controller: controller,
                        );
                      },
                    )),
                Center(
                  child: Obx(() => (controller.state.value is StateLoading)
                      ? const LoadingWidget()
                      : (controller.state.value is StateEmptyData)
                          ? const EmptyDataWidget()
                          : Container()),
                )
              ],
            )),
        floatingActionButton: GestureDetector(
          onTap: () {
            controller.newStaff();
          },
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.circular(1000)),
            child: const Center(
                child: Icon(
              FontAwesomeIcons.userPlus,
              color: Colors.white,
            )),
          ),
        ));
  }
}
