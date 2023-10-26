import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/card_control.dart';
import 'package:pet_care/widgets/product_cart.dart';
import 'package:pet_care/widgets/search_field.dart';
import 'package:pet_care/widgets/service_card.dart';
import '../../model/state.dart';
import '../../widgets/loading.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
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
                      ) ,
                      CardControl(
                        image: 'images/warehouse.png',
                        text: 'Nhập kho',
                        onTap: () {
                          controller.goWarehouse();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchField(
                  text: 'Tìm kiếm sản phẩm',
                  onChange: (value) {
                    controller.searchProduct(value);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    controller.isExpandProduct.value =
                        !controller.isExpandProduct.value;
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(text: 'Sản phẩm'),
                          Obx(() => Icon(
                              (controller.isExpandProduct.value == true)
                                  ? Icons.expand_more
                                  : Icons.expand_less))
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() => (controller.isExpandProduct.value)
                    ? Expanded(
                        child: GridView.builder(
                              itemCount: controller.products.value.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.65),
                              itemBuilder: (context, index) {
                                return ProductCart(
                                  controller: controller,
                                  product: controller.products.value[index],
                                  isAdmin: true,
                                );
                              },
                            ),
                      )
                    : Container()),
                GestureDetector(
                  onTap: () {
                    controller.isExpandService.value =
                        !controller.isExpandService.value;
                  },
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppText(text: 'Dịch vụ'),
                          Obx(() => Icon(
                              (controller.isExpandService.value == true)
                                  ? Icons.expand_more
                                  : Icons.expand_less))
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() => (controller.isExpandService.value)
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: controller.services.length,
                          itemBuilder: (context, index) {
                            return ServiceCard(
                              service: controller.services[index],
                            );
                          },
                        ),
                      )
                    : Container())
              ],
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
