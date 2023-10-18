import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/widgets/app_text.dart';

class CardStaff extends StatelessWidget {
  final UserResponse staff;
  final int index;
  final StaffController controller;

  const CardStaff(
      {super.key,
      required this.staff,
      this.index = 0,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: (index % 2 == 0) ? MyColors.cardColor : MyColors.cardColor2,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: (staff.avatar == null || staff.avatar!.isEmpty)
                      ? Image.asset(
                          'images/profile.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          staff.avatar!,
                          fit: BoxFit.cover,
                        )),
            ),
            Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: '${staff.name}',
                    isBold: true,
                  ),
                  AppText(
                    text: '${staff.phoneNumber}',
                    color: MyColors.textColor,
                  ),
                  AppText(
                    text: '${staff.address}',
                    color: MyColors.textColor,
                    size: 14,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    controller.deleteUser(staff);
                  },
                  child: const Icon(
                    Icons.delete_outline_outlined,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    controller.editStaff(staff);
                  },
                  child: const Icon(
                    FontAwesomeIcons.edit,
                    size: 28,
                    color: MyColors.primaryColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
