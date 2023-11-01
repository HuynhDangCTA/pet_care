import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/model/room.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/crop_image.dart';
import 'package:pet_care/util/dialog_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';

class RoomController extends GetxController {
  RxInt currentStep = 0.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  Rx<File?> imageFile = Rx(null);
  Rx<AppState> state = Rx(StateSuccess());
  Rx<Uint8List?> webImage = Rx(Uint8List(8));
  Rx<Image?> image = Rx(null);

  RxList<Room> roomsCat = <Room>[].obs;
  RxList<Room> roomsDog = <Room>[].obs;

  @override
  void onInit() async {
    await getAllRoomCat();
    await getAllRoomDog();
    super.onInit();
  }

  void goNewRoomCat() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    Get.toNamed(RoutesConst.roomCat);
  }

  void goNewRoomDog() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    Get.toNamed(RoutesConst.roomDog);
  }

  Future getAllRoomCat() async {
    await FirebaseHelper.getAllRoomCat().then((value) {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          Room room = Room.fromDocument(item.data() as Map<String, dynamic>);
          room.id = item.id;
          roomsCat.add(room);
        }
      }
    });
  }

  Future getAllRoomDog() async {
    await FirebaseHelper.getAllRoomDog().then((value) {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          Room room = Room.fromDocument(item.data() as Map<String, dynamic>);
          room.id = item.id;
          roomsDog.add(room);
        }
      }
    });
  }

  Future newRoomCat() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (imageFile.value == null) {
      DialogUtil.showSnackBar('Chưa chọn hình ảnh');
      return;
    }

    if (name.isEmpty || description.isEmpty) return;

    state.value = StateLoading();

    bool exits = await FirebaseHelper.isExistRoomCat(name);
    if (exits) {
      DialogUtil.showSnackBar("Tên đã tồn tại");
      state.value = StateSuccess();
      return;
    }

    String? image = '';

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'room/$name*${DateTime.now().millisecondsSinceEpoch}');
      } else {
        return;
      }
    } else {
      image = await FirebaseHelper.uploadFile(imageFile.value!,
          'room/$name*${DateTime.now().millisecondsSinceEpoch}');
    }

    Room room = Room(name: name, description: description, image: image);

    await FirebaseHelper.newRoomCat(room).then((value) {
      state.value = StateSuccess();
      room.id = value.id;
      roomsCat.add(room);
      DialogUtil.showSnackBar('Thêm thành công');
    });
  }

  Future newRoomDog() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (imageFile.value == null) {
      DialogUtil.showSnackBar('Chưa chọn hình ảnh');
      return;
    }

    if (name.isEmpty || description.isEmpty) return;

    state.value = StateLoading();

    bool exits = await FirebaseHelper.isExistRoomDog(name);

    if (exits) {
      DialogUtil.showSnackBar('Tên đã tồn tại');
      state.value = StateSuccess();
      return;
    }

    String? image = '';

    if (kIsWeb) {
      if (webImage.value != null) {
        image = await FirebaseHelper.uploadFileWeb(webImage.value!,
            'room/$name*${DateTime.now().millisecondsSinceEpoch}');
      } else {
        return;
      }
    } else {
      image = await FirebaseHelper.uploadFile(imageFile.value!,
          'room/$name*${DateTime.now().millisecondsSinceEpoch}');
    }

    Room room = Room(name: name, description: description, image: image);

    await FirebaseHelper.newRoomDog(room).then((value) {
      state.value = StateSuccess();
      room.id = value.id;
      roomsDog.add(room);
      DialogUtil.showSnackBar('Thêm thành công');
    });
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

  void onPick(Room room, bool isCat, int index) {
    Get.defaultDialog(
        title: 'Thông tin',
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Tên phòng: ${room.name ?? ''}',
                color: MyColors.primaryColor,
                size: 20,
              ),
              AppText(text: 'Mô tả: ${room.description ?? ''}'),
              AppText(text: 'Trạng thái: ${room.isEmpty ? 'Trống' : 'Đầy'}'),
              const SizedBox(
                height: 10,
              ),
              AppButton(
                onPressed: () async {
                  if (room.isEmpty) {
                    if (isCat) {
                      await bookRoomCat(index);
                    } else {
                      await bookRoomDog(index);
                    }
                  } else {
                    if (isCat) {
                      await checkOutCat(index);
                    } else {
                      await checkOutDog(index);
                    }
                  }
                },
                text: (room.isEmpty) ? 'Đặt phòng' : 'Trả phòng',
                isShadow: false,
                isResponsive: true,
              )
            ],
          ),
        ));
  }

  Future bookRoomCat(int index) async {
    roomsCat[index].isEmpty = false;
    await FirebaseHelper.bookRoomCat(roomsCat[index]).then((value) async {
      Get.back();
      DialogUtil.showSnackBar('Đặt thành công');
      roomsCat.clear();
      await getAllRoomCat();
    });
  }

  Future bookRoomDog(int index) async {
    roomsDog[index].isEmpty = false;
    await FirebaseHelper.bookRoomDog(roomsDog[index]).then((value) async {
      Get.back();
      DialogUtil.showSnackBar('Đặt thành công');
      roomsDog.clear();
      await getAllRoomDog();
    });
  }

  Future checkOutCat(int index) async {
    roomsCat[index].isEmpty = true;
    await FirebaseHelper.checkOutCat(roomsCat[index]).then((value) async {
      Get.back();
      DialogUtil.showSnackBar('Trả phòng thành công');
      roomsCat.clear();
      await getAllRoomCat();
    });
  }

  Future checkOutDog(int index) async {
    roomsDog[index].isEmpty = true;
    await FirebaseHelper.checkOutDog(roomsDog[index]).then((value) async {
      Get.back();
      DialogUtil.showSnackBar('Trả phòng thành công');
      roomsDog.clear();
      await getAllRoomDog();
    });
  }
}
