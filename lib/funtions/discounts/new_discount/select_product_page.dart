import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/discounts/new_discount/new_discount_controller.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/widgets/product_cart.dart';
import 'package:pet_care/widgets/search_field.dart';

class SelectProductPage extends GetView<NewDiscountController> {
  const SelectProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchField(
              text: 'Tìm kiếm sản phẩm',
              onChange: (value) {
                controller.searchProduct(value);
              },
            ),
            const SizedBox(height: 10,),
            Expanded(
              flex: 3,
              child: Obx(() => GridView.builder(
                    itemCount: controller.productFilter.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.65),
                    itemBuilder: (context, index) {
                      Product product = controller.productFilter.value[index];
                      return Stack(
                        children: [
                          ProductCart(
                            isHot: (index < 5) ? true : false,
                            product: product,
                            isAdmin: false,
                            onPick: (product) {
                              controller.onPick(index, product);
                            },
                          ),
                          (product.selected)
                              ? GestureDetector(
                                  onTap: () {
                                    controller.onPick(index, product);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white38,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child:
                                          Image.asset('images/ic_checked.png'),
                                    ),
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
