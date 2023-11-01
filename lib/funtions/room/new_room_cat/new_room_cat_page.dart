import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/room/room_controller.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/loading.dart';
import 'package:pet_care/widgets/text_form_field.dart';

class NewRoomCatPage extends GetView<RoomController> {
  const NewRoomCatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm phòng cho mèo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.pickImage();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Obx(() => controller.image.value != null
                        ? controller.image.value!
                        : const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 60,
                            color: Colors.white,
                          )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextFormField(
                  label: 'Tên phòng',
                  controller: controller.nameController,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  label: 'Mô tả',
                  keyboardType: TextInputType.text,
                  controller: controller.descriptionController,
                  isCurrency: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppButton(
                  onPressed: () {
                    controller.newRoomCat();
                  },
                  isResponsive: true,
                  text: 'Thêm',
                )
              ],
            ),
            Obx(() => (controller.state.value is StateLoading) ? const Center(
              child: LoadingWidget(),
            ): Container())
          ],
        ),
      ),
    );
  }
}
