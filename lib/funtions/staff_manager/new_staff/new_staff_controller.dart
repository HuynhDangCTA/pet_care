import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/funtions/staff_manager/staff_controller.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/encode_util.dart';
import '../../../core/constants.dart';
import '../../../util/crop_image.dart';
import '../../../widgets/card_control.dart';

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

  String? typeAccount;
  UserResponse? staff = Get.arguments;
  bool isEdit = false;

  RxBool passwordInVisible = true.obs;

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  @override
  void onInit() {
    if (staff != null) {
      usernameController.text = staff!.username!;
      passwordController.text = staff!.password!;
      fullNameController.text = staff!.name!;
      phoneController.text = staff!.phoneNumber!;
      addressController.text = staff!.address!;
      typeAccount = staff!.type;
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

  Future register() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String fullname = fullNameController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String? image = '';
    String type = (typeAccount != null) ? typeAccount! : Constants.typeStaff;
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
        image = await FirebaseHelper.uploadFileWeb(
            webImage.value!, 'avatar/avatar_$username');
      }
    } else {
      if (imageFile.value != null) {
        image = await FirebaseHelper.uploadFile(
            imageFile.value!, 'avatar/avatar_$username');
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
      DialogUtil.showSnackBar('Thêm mới thành công');
      clearEditText();
    }).catchError((error) {
      state.value = StateError(error.toString());
    });
  }

  Future edit() async {
    String id = staff!.id!;
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    String fullname = fullNameController.text.trim();
    String phone = phoneController.text.trim();
    String? image = '';
    String address = addressController.text.trim();
    String type = (typeAccount != null) ? typeAccount! : Constants.typeStaff;
    if (username.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      return;
    }

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(
            webImage.value!, 'avatar/avatar_$username');
      }
    } else {
      if (imageFile.value != null) {
        image = await FirebaseHelper.uploadFile(
            imageFile.value!, 'avatar/avatar_$username');
      }
    }

    Map<String, dynamic> data = {
      Constants.username: username,
      Constants.password: EncodeUtil.generateSHA256(password),
      Constants.fullname: fullname,
      Constants.phone: phone,
      Constants.address: address,
      Constants.typeAccount: type
    };

    if (image != null && image.isNotEmpty) {
      data.assign(Constants.image, image);
    }

    state.value = StateLoading();
    await FirebaseHelper.editUser(id, data).then((value) {
      state.value = StateSuccess();
      Get.back();
      DialogUtil.showSnackBar('Cập nhật thành công');
    }).catchError((error) {
      debugPrint('error update: ${error.toString()}');
      DialogUtil.showSnackBar('Cập nhật thất bại');
      state.value = StateError(error.toString());
    });
  }

  void clearEditText() {
    usernameController.text = ' ';
    passwordController.text = ' ';
    fullNameController.text = ' ';
    addressController.text = ' ';
    phoneController.text = ' ';
  }

  void pickImage() async {
    await Get.bottomSheet(Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CardControl(
              image: 'images/camera.png',
              text: 'Chụp ảnh',
              onTap: () async {
                await pickImageFromCamera();
                Get.back();
              }),
          CardControl(
              image: 'images/gallery.png',
              text: 'Bộ nhớ',
              onTap: () async {
                await pickImageFromGallery();
                Get.back();
              }),
        ],
      ),
    ));
  }

  Future pickImageFromCamera() async {
    final XFile? imagePick = await picker.pickImage(source: ImageSource.camera);
    if (!kIsWeb) {
      if (imagePick != null) {
        CroppedFile? croppedFile =
            await CropImage.cropImage(imagePick.path, Get.context!);
        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
        }
        if (imageFile.value != null) {
          image.value = Image.file(
            imageFile.value!,
            fit: BoxFit.cover,
          );
        }
      }
    } else if (kIsWeb) {
      if (imagePick != null) {
        CroppedFile? croppedFile =
            await CropImage.cropImage(imagePick.path, Get.context!);
        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
          webImage.value = await croppedFile.readAsBytes();
        }
        if (webImage.value != null) {
          image.value = Image.memory(
            webImage.value!,
            fit: BoxFit.cover,
          );
        }
      }
    }
  }

  Future pickImageFromGallery() async {
    final XFile? imagePick =
        await picker.pickImage(source: ImageSource.gallery);
    if (!kIsWeb) {
      if (imagePick != null) {
        CroppedFile? croppedFile =
            await CropImage.cropImage(imagePick.path, Get.context!);
        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
        }
        if (imageFile.value != null) {
          image.value = Image.file(
            imageFile.value!,
            fit: BoxFit.cover,
          );
        }
      }
    } else if (kIsWeb) {
      if (imagePick != null) {
        CroppedFile? croppedFile =
            await CropImage.cropImage(imagePick.path, Get.context!);
        if (croppedFile != null) {
          imageFile.value = File(croppedFile.path);
          webImage.value = await croppedFile.readAsBytes();
        }

        if (webImage.value != null) {
          image.value = Image.memory(
            webImage.value!,
            fit: BoxFit.cover,
          );
        }
      }
    }
  }
}
