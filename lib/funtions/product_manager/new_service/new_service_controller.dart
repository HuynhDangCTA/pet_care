import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/util/crop_image.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/file_util.dart';
import 'package:pet_care/util/loading.dart';

import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';
import '../../../util/number_util.dart';
import '../../../widgets/card_control.dart';

class NewServiceController extends GetxController {
  ServiceModel? service = Get.arguments;
  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<AppState> state = Rx(StateSuccess());
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image?> image = Rx(null);
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxList<TextEditingController> optionControllers =
      [TextEditingController()].obs;
  RxList<TextEditingController> priceControllers =
      [TextEditingController()].obs;
  RxBool isByDate = false.obs;
  RxBool isDog = false.obs;
  RxBool isCat = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (service != null) {
      image.value = Image.network(service!.image!);
      nameController.text = service!.name ?? '';
      descriptionController.text = service!.decription ?? '';
      isByDate.value = service!.isByDate;
      for (int i = 0; i < service!.options!.values.length; i++) {
        if (i == 0) {
          optionControllers[0].text = service!.options!.keys.toList()[0];
          priceControllers[0].text =
              service!.options!.values.toList()[0].toString();
        } else {
          optionControllers.add(
              TextEditingController(text: service!.options!.keys.toList()[i]));
          priceControllers.add(TextEditingController(
              text: service!.options!.values.toList()[i].toString()));
        }
      }
    }
  }

  void newOption() {
    optionControllers.add(TextEditingController());
    priceControllers.add(TextEditingController());
  }

  void deleteOption() {
    optionControllers.removeLast();
    priceControllers.removeLast();
  }

  Future newService() async {
    if (imageFile.value == null) {
      state.value = StateError('Chưa chọn hình ảnh');
      return;
    }
    String name = nameController.text;
    String description = descriptionController.text;
    if (name.isEmpty || description.isEmpty) {
      return;
    }

    Map<String, dynamic> options = {};
    for (var index = 0; index < optionControllers.length; index++) {
      if (optionControllers[index].text.isEmpty ||
          priceControllers[index].text.isEmpty) return;
      int price =
          NumberUtil.parseCurrency(priceControllers[index].text).toInt();
      options.addAll({optionControllers[index].text: price});
    }
    String? image = '';
    Loading.showLoading();
    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'services/$name*${DateTime.now().millisecondsSinceEpoch}');
      } else {
        return;
      }
    } else {
      image = await FirebaseHelper.uploadFile(imageFile.value!,
          'services/$name*${DateTime.now().millisecondsSinceEpoch}');
    }

    ServiceModel serviceModel = ServiceModel(
        name: name,
        options: options,
        image: image,
        isByDate: isByDate.value,
        isDog: isDog.value,
        isCat: isCat.value,
        decription: description);
    await FirebaseHelper.newService(serviceModel).then((value) {
      state.value = StateSuccess();
      clearEditText();
    }).catchError((error) {
      state.value = StateError(error.toString());
    });
    Loading.hideLoading();
  }

  Future updateService() async {
    String name = nameController.text;
    String description = descriptionController.text;
    String? image = service!.image;

    if (name.isEmpty || description.isEmpty) {
      return;
    }
    Map<String, dynamic> options = {};
    for (var index = 0; index < optionControllers.length; index++) {
      if (optionControllers[index].text.isEmpty ||
          priceControllers[index].text.isEmpty) return;
      int price =
          NumberUtil.parseCurrency(priceControllers[index].text).toInt();
      options.addAll({optionControllers[index].text: price});
    }
    state.value = StateLoading();
    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(
            webImage.value!, 'services/${FileUtil.getFileNameFromUrl(image!)}');
      }
    } else {
      if (imageFile.value != null) {
        image = await FirebaseHelper.uploadFile(imageFile.value!,
            'services/${FileUtil.getFileNameFromUrl(image!)}');
      }
    }

    Map<String, dynamic> data = {
      Constants.name: name,
      Constants.description: description,
      Constants.options: options,
      Constants.byDate: isByDate.value,
    };

    if (image != null) {
      data[Constants.image] = image;
    }
    print('data update: $data');

    await FirebaseHelper.updateService(service!.id!, data).then((value) {
      state.value = StateSuccess();
      Get.back();
      DialogUtil.showSnackBar('Cập nhật thành công');
    });
  }

  void pickImage() async {
    await Get.bottomSheet(Container(
      padding: EdgeInsets.only(bottom: 20, top: 20),
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

  void clearEditText() {
    nameController.clear();
    optionControllers.clear();
    priceControllers.clear();
    optionControllers.add(TextEditingController());
    priceControllers.add(TextEditingController());
    imageFile.value = null;
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

  @override
  void onClose() {
    super.onClose();
    Get.find<ProductController>().getAllService();
  }
}
