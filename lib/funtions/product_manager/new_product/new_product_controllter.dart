import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/util/crop_image.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/file_util.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/dropdown.dart';
import 'package:pet_care/widgets/text_form_field.dart';

import '../../../core/constants.dart';
import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';
import '../../../widgets/card_control.dart';

class NewProductController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController unitController = TextEditingController();

    final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<AppState> state = Rx(StateSuccess());
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image?> image = Rx(null);

  RxList products = [].obs;
  RxList<DropDownItem> typeProducts = <DropDownItem>[].obs;
  Rx<String?> valueTypeProduct = Rx(null);
  Product? product = Get.arguments;

  @override
  void onInit() async {
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
      valueTypeProduct.value = product!.type;
      unitController.text = product!.unit!;
      descriptionController.text = product!.description!;
    }
    await getTypeProducts();
  }

  Future newTypeProduct() async {
    TextEditingController nameController = TextEditingController();
    Get.defaultDialog(
        title: 'Thêm mới',
        content: Column(
          children: [
            MyTextFormField(
              label: 'Loại sản phẩm',
              controller: nameController,
            ),
          ],
        ),
        actions: [
          AppButton(
            onPressed: () async {
              String name = nameController.text;
              if (name.isEmpty) {
                return;
              }
              await FirebaseHelper.newTypeProduct(name).then((value) {
                Get.back();
                typeProducts.add(DropDownItem(text: name, value: name));
              });
            },
            text: 'Thêm',
            isShadow: false,
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Đóng',
            backgroundColor: Colors.grey,
            isShadow: false,
          )
        ]);
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

  void newProduct() async {
    if (imageFile.value == null) {
      state.value = StateError('Chưa chọn hình ảnh');
      return;
    }
    String name = nameController.text;
    int price = NumberUtil.parseCurrency(priceController.text).toInt();
    String? image = '';
    String description = descriptionController.text;
    String unit = unitController.text;
    if (name.isEmpty || price == 0 || description.isEmpty || unit.isEmpty) {
      return;
    }
    if (valueTypeProduct.value == null) return;
    state.value = StateLoading();

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

    Product product = Product(
        name: name,
        price: price,
        description: description,
        image: image,
        unit: unit,
        type: valueTypeProduct.value!);

    await FirebaseHelper.newProduct(product).then((value) {
      state.value = StateSuccess();
      DialogUtil.showSnackBar('Thêm mới thành công');
      clearEditText();
    }).catchError((error) {
      state.value = StateError(error.toString());
      DialogUtil.showSnackBar('Thêm mới thất bại');
    });
  }

  void editProduct() async {
    state.value = StateLoading();
    String name = nameController.text;
    String unit = unitController.text;
    String description = descriptionController.text;
    int price = NumberUtil.parseCurrency(priceController.text).toInt();
    String? image = product!.image;

    if (name.isEmpty ||
        priceController.text.isEmpty ||
        unit.isEmpty ||
        description.isEmpty ||
        price <= 0) {
      return;
    }

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
    Map<String, dynamic> data = {
      Constants.name: name,
      Constants.description: description,
      Constants.price: price,
      Constants.unit: unit,
      Constants.type: valueTypeProduct.value
    };

    if (image != null) {
      data.assign(Constants.image, image);
    }

    await FirebaseHelper.updateProduct(product!.id!, data).then((value) {
      state.value = StateSuccess();
      DialogUtil.showSnackBar('Cập nhật thành công');
    });
  }

  Future getTypeProducts() async {
    await FirebaseHelper.getTypeProducts().then((value) {
      for (var item in value.docs) {
        var dropdownItem = DropDownItem(
            text: item[Constants.type], value: item[Constants.type]);
        typeProducts.add(dropdownItem);
      }
    });
  }

  void clearEditText() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    image.value = Image.network(
      product!.image!,
      fit: BoxFit.cover,
    );
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
    Get.find<ProductController>().getAllProducts();
  }
}
