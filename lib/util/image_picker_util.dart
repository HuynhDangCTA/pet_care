
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:pet_care/widgets/card_control.dart';

class ImagePickerUtil {
  static final ImagePicker picker = ImagePicker();

  static Future<Image?> selectOption() async {
    Image? image;
    await Get.bottomSheet(Container(
      padding: EdgeInsets.only(bottom: 20, top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
      ),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CardControl(
              image: 'images/camera.png', text: 'Chụp ảnh', onTap: () async {
            image = await pickImageFromCamera();
          }),
          CardControl(
              image: 'images/gallery.png', text: 'Bộ nhớ', onTap: () async {
            image = await pickImageFromGallery();
          }),
        ],
      ),
    ));

    return image;
  }

  static Future<Image?> pickImageFromGallery() async {
    Image? image;
    final XFile? imagePick = await picker.pickImage(source: ImageSource.gallery);
    if (!kIsWeb) {
      if (imagePick != null) {
        File? imageFile = File(imagePick!.path);
        if (imageFile != null) {
          image = Image.file(imageFile!, fit: BoxFit.cover,);
        }

      }
    } else if (kIsWeb) {
      Uint8List? webImage = await imagePick?.readAsBytes();
      if (webImage != null) {
        image = Image.memory(webImage!, fit: BoxFit.cover,);
      }
    }
    return image;
  }

  static Future<Image?> pickImageFromCamera() async {
    Image? image;
    final XFile? imagePick = await picker.pickImage(source: ImageSource.camera);
    if (!kIsWeb) {
      if (imagePick != null) {
        File? imageFile = File(imagePick!.path);
        if (imageFile != null) {
          image = Image.file(imageFile!, fit: BoxFit.cover,);
        }

      }
    } else if (kIsWeb) {
      Uint8List? webImage = await imagePick?.readAsBytes();
      if (webImage != null) {
        image = Image.memory(webImage!, fit: BoxFit.cover,);
      }
    }
    return image;
  }
}
