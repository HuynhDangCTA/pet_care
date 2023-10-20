import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/routes/routes_const.dart';

import '../../model/state.dart';
import '../../model/user_response.dart';
import '../../network/firebase_helper.dart';

class RegisterController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  RxBool passwordInVisible = true.obs;
  RxBool repasswordInVisible = true.obs;
  Rx<AppState> state = Rx<AppState>(StateSuccess());

  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image> image = Rx(Image.asset('images/profile.png'));

  void changeHideOrShowPassword() {
    passwordInVisible.value = !passwordInVisible.value;
  }

  void changeHideOrShowRePassword() {
    repasswordInVisible.value = !repasswordInVisible.value;
  }

  Future register() async {
    String username = userNameController.text;
    String password = passwordController.text;
    String rePassword = repasswordController.text;
    String fullname = fullNameController.text;
    String phone = userNameController.text;
    String address = addressController.text;
    String? image = '';
    String type = Constants.typeCustomer;

    if (username.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        phone.isEmpty ||
        address.isEmpty) {
      return;
    }

    if (password != rePassword) {
      return;
    }

    state.value = StateLoading();

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
        password: password,
        name: fullname,
        phoneNumber: phone,
        address: address,
        avatar: image,
        type: type);

    await FirebaseHelper.register(data).then((value) {
      state.value = StateSuccess();
      Get.offAndToNamed(RoutesConst.homeCustomer);
    }).catchError((error) {
      state.value = StateError(error.toString());
    });
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
