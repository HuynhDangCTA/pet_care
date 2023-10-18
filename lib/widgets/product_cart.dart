import 'package:flutter/material.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';

import '../model/product.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final ProductController? controller;
  final Function(Product)? onPick;

  const ProductCart(
      {super.key,
      required this.product,
      this.isAdmin = false,
      this.controller,
      this.onPick});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (onPick != null) {
          onPick!(product);
        }
        if (controller != null) {
          controller!.showQRCodeProduct(product);
        }
      },
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                width: size.width,
                height: 160,
                child: (product.image != null)
                    ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'images/product_demo.jpg',
                        fit: BoxFit.contain,
                      )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              product.name!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${NumberUtil.formatCurrency(product.price)}',
                              style: const TextStyle(
                                color: MyColors.primaryColor,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Số lượng: ${product.amount}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (isAdmin)
                      ? Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () {
                                  controller?.editProduct(product);
                                },
                                icon: const Icon(
                                  Icons.mode_edit_outline_outlined,
                                  color: MyColors.primaryColor,
                                )),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
