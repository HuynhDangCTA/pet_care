import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/widgets/card_control.dart';
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
      body: SingleChildScrollView(
        child: Container(
            width: size.width,
            // height: size.height,
            padding:
                const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardControl(
                    image: 'images/ic_newstaff.png',
                    text: 'Thêm nhân viên',
                    onTap: () {
                      controller.newStaff();
                    }),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Obx(() => Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.staffs.value.length,
                            itemBuilder: (context, index) {
                              return CardStaff(
                                index: index,
                                staff: controller.staffs[index],
                                controller: controller,
                              );
                            },
                          ),
                        )),
                    Center(
                      child: Obx(() => (controller.state.value is StateLoading)
                          ? const LoadingWidget()
                          : (controller.state.value is StateEmptyData)
                              ? const EmptyDataWidget()
                              : Container()),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
