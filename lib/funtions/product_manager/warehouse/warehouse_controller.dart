import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/warehouse.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/util/loading.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/card_control.dart';
import 'package:pet_care/widgets/text_form_field.dart';
import '../../../model/item_warehouse.dart';
import '../../../model/state.dart';
import '../../../routes/routes_const.dart';
import '../../../util/crop_image.dart';

class WarehouseController extends GetxController {
  List<Product> products = Get.find<ProductController>().productsGet;

  RxList<Product> productFilter = <Product>[].obs;
  RxInt sizeList = 0.obs;
  RxInt priceTotal = 0.obs;

  Rx<Warehouse?> warehouseItems = Rx(null);

  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<AppState> state = Rx(StateSuccess());
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image?> image = Rx(null);

  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    productFilter.addAll(products);
    warehouseItems.value = Warehouse(proudcts: []);
  }

  void searchProduct(String? value) {
    productFilter.clear();
    if (value == null || value.isEmpty) {
      productFilter.addAll(products);
      return;
    }
    for (Product product in products) {
      if (product.name!
          .toLowerCase()
          .trim()
          .contains(value.toLowerCase().trim())) {
        productFilter.add(product);
      }
    }
  }

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
    }
  }

  String formatDate(value) {
    return DateFormat("dd-MM-yyyy").format(value).toString();
  }

  void newWarehouse() async {
    if (imageFile.value == null) {
      state.value = StateError('Chưa chọn hình ảnh');
      DialogUtil.showSnackBar('Chưa chọn hình ảnh');
      return;
    }

    if (warehouseItems.value == null) return;
    if (warehouseItems.value!.proudcts!.isEmpty) return;

    Loading.showLoading();
    String? image = '';

    String name = selectedDate.value.millisecondsSinceEpoch.toString();

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'warehouse/$name*${DateTime.now().millisecondsSinceEpoch}');
      } else {
        return;
      }
    } else {
      image = await FirebaseHelper.uploadFile(imageFile.value!,
          'warehouse/$name*${DateTime.now().millisecondsSinceEpoch}');
    }

    warehouseItems.value!.image = image;
    warehouseItems.value!.timeCreated = selectedDate.value;
    await FirebaseHelper.newWarehouse(warehouseItems.value!)
        .then((value) async {
      for (var item in warehouseItems.value!.proudcts!) {
        item.product.amount = item.amount;
        item.product.priceInput = item.price;
        await FirebaseHelper.addProductToWarehouse(item.product, value.id);
        await FirebaseHelper.updateProductWarehouse(
            item.product.id!, item.amount, item.price);
      }

    });
    Get.back();
    Loading.hideLoading();
  }

  void newProduct() {
    Get.toNamed(RoutesConst.productWarehouse);
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

  void pickProduct(Product product) {
    TextEditingController amountController = TextEditingController(text: '1');
    TextEditingController priceController = TextEditingController();
    int index = -1;

    if (warehouseItems.value!.proudcts!.isNotEmpty) {
      for (int i = 0; i < warehouseItems.value!.proudcts!.length; i++) {
        if (warehouseItems.value!.proudcts![i].product.id == product.id) {
          amountController.text =
              warehouseItems.value!.proudcts![i].amount.toString();
          priceController.text =
              warehouseItems.value!.proudcts![i].price.toString();
          index = i;
          break;
        }
      }
    }

    Get.defaultDialog(
        title: 'Nhập số lượng',
        content: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                label: 'Số lượng',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextFormField(
                label: 'Giá nhập',
                controller: priceController,
                keyboardType: TextInputType.number,
                isCurrency: true,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            onPressed: () async {
              String amount = amountController.text;
              int price =
                  NumberUtil.parseCurrency(priceController.text).toInt();
              if (amount.isNotEmpty && int.parse(amount) > 0 && price > 0) {
                if (index < 0) {
                  warehouseItems.value!.proudcts!
                      .add(ItemWarehouse(product, int.parse(amount), price));
                  sizeList.value = warehouseItems.value!.proudcts!.length;
                  priceTotal.value = int.parse(amount) * price;
                  warehouseItems.value!.price =
                      warehouseItems.value!.price ?? 0 + priceTotal.value;
                } else {
                  priceTotal.value -=
                      warehouseItems.value!.proudcts![index].price *
                          warehouseItems.value!.proudcts![index].amount;
                  warehouseItems.value!.price =
                      warehouseItems.value!.price ?? 0 - priceTotal.value;
                  warehouseItems.value!.proudcts![index].price = price;
                  warehouseItems.value!.proudcts![index].amount =
                      int.parse(amount);
                  priceTotal.value = int.parse(amount) * price;
                  warehouseItems.value!.price =
                      warehouseItems.value!.price ?? 0 + priceTotal.value;
                }
                Get.back();
              }
            },
            text: 'Lưu',
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Đóng',
            backgroundColor: Colors.grey.withOpacity(0.4),
          ),
        ]);
  }

  void deleteItem(int index) {
    priceTotal.value -= (warehouseItems.value!.proudcts![index].price *
        warehouseItems.value!.proudcts![index].amount);
    warehouseItems.value!.proudcts!.removeAt(index);
    sizeList.value = warehouseItems.value!.proudcts!.length;
  }

  Future pickImageFromCamera() async {
    final XFile? imagePick = await picker.pickImage(source: ImageSource.camera);
    if (!kIsWeb) {
      if (imagePick != null) {
        CroppedFile? croppedFile =
            await CropImage.cropImageInvoice(imagePick.path, Get.context!);
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
            await CropImage.cropImageInvoice(imagePick.path, Get.context!);
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
            await CropImage.cropImageInvoice(imagePick.path, Get.context!);
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
            await CropImage.cropImageInvoice(imagePick.path, Get.context!);
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
    Get.find<ProductController>().getAllProducts();
    super.onClose();
  }
}
