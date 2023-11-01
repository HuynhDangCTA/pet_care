import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/number_selected.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final Function onChangeSelected;

  const CartItem(
      {super.key, required this.product, required this.onChangeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: Get.width,
      padding: EdgeInsets.all(10),
      height: 140,
      child: Row(
        children: [
          Checkbox(
              value: true,
              onChanged: (value) {
                onChangeSelected(value);
              }),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              product.image ?? '',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                text: product.name ?? '',
                maxLines: 2,
              ),
              AppText(text: '1000000'),
              NumberSelected(increase: () {}, decrease: () {})
            ],
          )
        ],
      ),
    );
  }
}
