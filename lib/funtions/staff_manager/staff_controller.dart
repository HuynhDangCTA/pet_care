import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/staff_manager/new_staff/new_staff_controller.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';

import '../../core/constants.dart';
import '../../model/user_response.dart';
import '../../model/state.dart';
import '../../network/firebase_helper.dart';

class StaffController extends GetxController {
  Rx<AppState> state = Rx(StateSuccess());
  RxList staffs = [].obs;

  @override
  void onInit() async {
    super.onInit();
    state.value = StateLoading();
    await fetchData();
  }

  void newStaff() {
    Get.lazyPut(() => NewStaffController());
    Get.toNamed(RoutesConst.newStaff);
  }

  Future<void> fetchData() async {
    state.value = StateLoading();
    await FirebaseHelper.getAllStaff('baoson').then((value) {
      state.value = StateSuccess();
      if (value != null && value.docs.length > 0) {
        List<UserResponse> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          UserResponse staff = UserResponse(
              id: doc.id,
              username: doc[Constants.username],
              password: doc[Constants.password],
              address: doc[Constants.address],
              name: doc[Constants.fullname],
              phoneNumber: doc[Constants.phone],
              isDeleted: doc[Constants.isDeleted],
              avatar: doc[Constants.avt],
              type: doc[Constants.typeAccount]);
          if (!staff.isDeleted) {
            result.add(staff);
          }
        }
        staffs.value = result;
        if (result.isEmpty) {
          state.value = StateEmptyData();
        }
      } else {
        state.value = StateEmptyData();
      }

    });
  }

  void editStaff(UserResponse staff) {
    Get.lazyPut(() => NewStaffController());
    Get.toNamed(RoutesConst.newStaff, arguments: staff);
  }


  void deleteUser(UserResponse user) {
    Get.dialog(AlertDialog(
      title: const AppText(
        text: "Xác nhận",
      ),
      content: AppText(
        text: 'Bạn có chắc chắn muốn xóa người dùng ${user.name}',
      ),
      actions: [
        AppButton(
          onPressed: () {
            FirebaseHelper.deletedUser(user)
                .then((value) {
               Get.back();
               staffs.remove(user);
            });
          },
          text: 'Đồng ý',
          height: 50,
        ),
        AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Hủy',
            backgroundColor: Colors.grey,
            height: 50,
            textColor: Colors.white,
            isShadow: true),
      ],
    ));
  }
}
