import 'package:flutter/material.dart';
import 'package:pet_care/core/colors.dart';
import 'package:pet_care/funtions/product_manager/product_controller.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_text.dart';

import '../model/product.dart';

class ProductCart extends StatelessWidget {
  final Product product;
  final bool isAdmin;
  final Function(Product) onPick;
  final bool isHot;
  final bool isCustomer;
  final bool isInvoice;
  final Function(Product)? addToCart;
  final Function(Product product)? editProduct;
  final Function(Product product)? deleteProduct;

  const ProductCart(
      {super.key,
      required this.product,
      this.isAdmin = false,
      this.deleteProduct,
      this.addToCart,
      this.isInvoice = false,
      this.isHot = false,
      this.isCustomer = false,
      this.editProduct,
      required this.onPick});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onPick(product);
      },
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                SizedBox(
                    width: size.width,
                    height: 160,
                    child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        child: (product.image != null)
                            ? Image.network(
                                product.image!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'images/product_demo.jpg',
                                fit: BoxFit.contain,
                              ))),
                (isHot && product.amount! > 0)
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10)),
                              child: Image.asset('images/hot.png')),
                        ),
                      )
                    : Container(),
                (product.amount == null || product.amount! <= 0)
                    ? Container(
                        width: size.width,
                        height: 160,
                        color: Colors.white38,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(1000)),
                              child: const AppText(
                                text: 'Hết hàng',
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
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
                                color: MyColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              NumberUtil.formatCurrency(product.price),
                              style: TextStyle(
                                color: MyColors.primaryColor,
                                decoration: (product.discount! > 0 && !isInvoice)
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          (product.discount! > 0 && !isInvoice)
                              ? Expanded(
                                  child: Text(
                                    NumberUtil.formatCurrency((product.price! *
                                        (100 - product.discount!) /
                                        100)),
                                    style: const TextStyle(
                                      color: MyColors.primaryColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                )
                              : Container(),
                          (!isCustomer)
                              ? Expanded(
                                  child: Text(
                                    'Số lượng: ${product.amount}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  (isCustomer)
                      ? IconButton(
                          onPressed: () {
                            addToCart!(product);
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: MyColors.primaryColor,
                          ))
                      : Container(),
                  (isAdmin)
                      ? Column(
                          children: [
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    deleteProduct!(product);
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_outlined,
                                    color: Colors.red,
                                  )),
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    editProduct!(product);
                                  },
                                  icon: const Icon(
                                    Icons.mode_edit_outline_outlined,
                                    color: MyColors.primaryColor,
                                  )),
                            ),
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
