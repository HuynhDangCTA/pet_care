import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:pet_care/widgets/product_cart.dart';
import 'package:pet_care/widgets/search_field.dart';
import 'package:pet_care/widgets/service_card.dart';
import 'package:pet_care/widgets/stepper.dart';

import '../../model/state.dart';
import '../../routes/routes_const.dart';
import '../../widgets/loading.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget productWidget = Obx(() => Column(
          children: [
            SearchField(
              text: 'Tìm kiếm sản phẩm',
              onChange: (value) {
                controller.searchProduct(value);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        children: List.generate(
                            controller.valueTypeFiller.value.length, (index) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: AppText(
                                  size: 13,
                                  text: controller.valueTypeFiller[index],
                                ),
                              ),
                            ),
                          );
                        }),
                      )),
                ),
                IconButton(
                    onPressed: () {
                      controller.showFillter();
                    },
                    icon: const Icon(
                      Icons.filter_list_alt,
                      color: MyColors.primaryColor,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: (controller.products.isNotEmpty)
                    ? GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.products.value.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 0.65),
                        itemBuilder: (context, index) {
                          return ProductCart(
                            isHot: (index < 5) ? true : false,
                            product: controller.products.value[index],
                            isAdmin: controller.isAdmin,
                            onPick: (product) {
                              controller.goProductDetail(product);
                            },
                            editProduct: (product) {
                              controller.editProduct(product);
                            },
                            deleteProduct: (product) {
                              controller.deleteProduct(product);
                            },
                          );
                        })
                    : const Center(child: EmptyDataWidget())),
          ],
        ));

    Widget serviceWidget = Obx(() => (controller.services.isNotEmpty)
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.services.length,
            itemBuilder: (context, index) {
              return ServiceCard(
                isAdmin: controller.isAdmin,
                service: controller.services[index],
                onDeleted: (ServiceModel service) {
                  controller.deleteService(service);
                },
                onPick: (service) {
                  Get.toNamed(RoutesConst.serviceDetail, arguments: service);
                },
                onEdit: (service) {
                  controller.editService(service);
                },
              );
            },
          )
        : const Center(child: EmptyDataWidget()));

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: size.width,
              height: Get.height,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CardControl(
                          image: 'images/ic_petfood.png',
                          text: 'Thêm sản phẩm mới',
                          onTap: () {
                            controller.goToNewProduct();
                          },
                        ),
                        CardControl(
                          image: 'images/ic_petservice.png',
                          text: 'Thêm dịch vụ mới',
                          onTap: () {
                            controller.goToNewService();
                          },
                        ),
                        CardControl(
                          image: 'images/warehouse.png',
                          text: 'Nhập kho',
                          onTap: () {
                            controller.goWarehouse();
                          },
                        ),
                        CardControl(
                          image: 'images/ic_room.png',
                          text: 'Phòng gửi thú cưng',
                          onTap: () {
                            controller.goRoomPage();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => MyStepper(
                          steps: [
                            MyStep(
                                title: 'Sản phẩm',
                                isActive: (controller.currentStep.value == 0)),
                            MyStep(
                                title: 'Dịch vụ',
                                isActive: (controller.currentStep.value == 1)),
                          ],
                          onStepTapped: (value) {
                            controller.changeScreen(value);
                          })),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => (controller.currentStep.value == 0)
                      ? Expanded(child: productWidget)
                      : Expanded(child: serviceWidget)),
                ],
              ),
            ),
          ),
          Center(
            child: Obx(() => (controller.state.value is StateLoading)
                ? const LoadingWidget()
                : Container()),
          )
        ],
      ),
    );
  }
}
