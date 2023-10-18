import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/util/file_util.dart';
import 'package:pet_care/util/image_picker_util.dart';
import 'package:pet_care/util/loading.dart';
import 'package:pet_care/util/number_util.dart';

import '../../../core/constants.dart';
import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';
import '../../../widgets/card_control.dart';

class NewProductController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<AppState> state = Rx(StateSuccess());
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image?> image = Rx(null);

  RxList products = [].obs;
  Product? product = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (product != null) {
      nameController.text = product!.name!;
      priceController.text = NumberUtil.formatCurrencyNotD(product!.price)
          .replaceAll('VND', '')
          .trim();
      image.value = Image.network(
        product!.image!,
        fit: BoxFit.cover,
      );
    }
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

  void newProduct() async {
    if (imageFile.value == null) {
      state.value = StateError('Chưa chọn hình ảnh');
      return;
    }
    String name = nameController.text;
    int price = NumberUtil.parseCurrency(priceController.text).toInt();
    String? image = '';

    if (name.isEmpty || price == 0) {
      return;
    }
    state.value = StateLoading();
    debugPrint('filepath: ${imageFile.value!.path}');
    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'prodcuts/$name*${DateTime.now().millisecondsSinceEpoch}');
      } else {
        return;
      }
    } else {
      image = await FirebaseHelper.uploadFile(imageFile.value!,
          'prodcuts/$name*${DateTime.now().millisecondsSinceEpoch}');
    }

    Product product = Product(name: name, price: price, image: image);

    await FirebaseHelper.newProduct(product).then((value) {
      state.value = StateSuccess();
      clearEditText();
    }).catchError((error) {
      state.value = StateError(error.toString());
    });
  }

  void editProduct() async {
    state.value = StateLoading();
    String name = nameController.text;
    int price = NumberUtil.parseCurrency(priceController.text).toInt();
    String? image = product!.image;

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'prodcuts/$name*${DateTime.now().millisecondsSinceEpoch}');
      }
    } else {
      if (imageFile.value != null) {
        image = await FirebaseHelper.uploadFile(imageFile.value!,
            'prodcuts/${FileUtil.getFileNameFromUrl(image!)}');
      }
    }

    Product productUpload =
        Product(id: product!.id, name: name, price: price, image: image);
    await FirebaseHelper.updateProduct(productUpload).then((value) {
      state.value = StateSuccess();
    });
  }

  @override
  void onClose() {
    super.onClose();
    Get.find<ProductController>().getAllProducts();
  }

  void clearEditText() {
    nameController.clear();
    priceController.clear();
    imageFile.value = null;
  }

  Future pickImageFromCamera() async {
    final XFile? imagePick = await picker.pickImage(source: ImageSource.camera);
    if (!kIsWeb) {
      if (imagePick != null) {
        imageFile.value = File(imagePick!.path);
        if (imageFile.value != null) {
          image.value = Image.file(
            imageFile.value!,
            fit: BoxFit.cover,
          );
        }
      }
    } else if (kIsWeb) {
      webImage.value = await imagePick?.readAsBytes();
      imageFile.value = File(imagePick!.path);
      if (webImage.value != null) {
        image.value = Image.memory(
          webImage.value!,
          fit: BoxFit.cover,
        );
      }
    }
  }

  Future pickImageFromGallery() async {
    final XFile? imagePick =
        await picker.pickImage(source: ImageSource.gallery);
    if (!kIsWeb) {
      if (imagePick != null) {
        imageFile.value = File(imagePick!.path);
        if (imageFile.value != null) {
          image.value = Image.file(
            imageFile.value!,
            fit: BoxFit.cover,
          );
        }
      }
    } else if (kIsWeb) {
      webImage.value = await imagePick?.readAsBytes();
      imageFile.value = File(imagePick!.path);
      if (webImage.value != null) {
        image.value = Image.memory(
          webImage.value!,
          fit: BoxFit.cover,
        );
      }
    }
  }
}
