import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/encode_util.dart';
import 'package:pet_care/widgets/dropdown.dart';

import '../../../core/constants.dart';

class NewStaffController extends GetxController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Rx<AppState> state = Rx(StateSuccess());
  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image> image = Rx(Image.asset('images/profile.png'));

  DropDownItem? typeAccount;
  UserResponse? staff = Get.arguments;
  bool isEdit = false;

  @override
  void onInit() {
    if (staff != null) {
      usernameController.text = staff!.username!;
      passwordController.text = staff!.password!;
      fullNameController.text = staff!.name!;
      phoneController.text = staff!.phoneNumber!;
      addressController.text = staff!.address!;
      isEdit = true;
    } else {
      isEdit = false;
    }
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    Get.find<StaffController>().fetchData();
  }

  void register() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String fullname = fullNameController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String? image = '';
    String type =
        (typeAccount != null) ? typeAccount!.value! : Constants.typeStaff;
    if (username.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      return;
    }
    state.value = StateLoading();
    clearEditText();

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'avatar/avatar_$username');
      }
    } else {
      if (imageFile.value != null) {
        image = await FirebaseHelper.uploadFile(imageFile.value!,
            'avatar/avatar_$username');
      }
    }

    UserResponse data = UserResponse(
        username: username,
        password: EncodeUtil.generateSHA256(password),
        name: fullname,
        phoneNumber: phone,
        address: address,
        avatar: image,
        type: type);
    await FirebaseHelper.register(data).then((value) {
      state.value = StateSuccess();
      clearEditText();
    }).catchError((error) {
      state.value = StateError(error.toString());
    });
  }

  void edit() async {
    String id = staff!.id!;
    String username = usernameController.text;
    String password = passwordController.text;
    String fullname = fullNameController.text;
    String phone = phoneController.text;
    String? image = '';
    String address = addressController.text;
    String type =
        (typeAccount != null) ? typeAccount!.value! : Constants.typeStaff;
    if (username.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      return;
    }

    if (imageFile.value != null) {
      image = await FirebaseHelper.uploadFile(
          imageFile.value!, 'avatar/avatar_$username}');
    }

    debugPrint('Download URL: $image');

    UserResponse data = UserResponse(
        id: id,
        username: username,
        password: EncodeUtil.generateSHA256(password),
        name: fullname,
        phoneNumber: phone,
        address: address,
        avatar: image,
        type: type);

    state.value = StateLoading();
    await FirebaseHelper.editUser(data).then((value) {
      state.value = StateSuccess();
      debugPrint('success update');
    }).catchError((error) {
      debugPrint('error update: ${error.toString()}');
      state.value = StateError(error.toString());
    });
  }

  void clearEditText() {
    usernameController.text = '';
    passwordController.text = '';
    fullNameController.text = '';
    addressController.text = '';
    phoneController.text = '';
  }

  void pickImage() async {
    final XFile? imagePick = await picker.pickImage(source: ImageSource.gallery);
    if (!kIsWeb) {
      if (imagePick != null) {
        imageFile.value = File(imagePick!.path);
        if (imageFile.value != null) {
          image.value = Image.file(imageFile.value!, fit: BoxFit.cover,);
        }

      }
    } else if (kIsWeb) {
       webImage.value = await imagePick?.readAsBytes();
       imageFile.value =  File(imagePick!.path);
       if (webImage.value != null) {
         image.value = Image.memory(webImage.value!, fit: BoxFit.cover,);
       }
    }
  }

}