import 'package:flutter/material.dart';
import 'package:pet_care/widgets/app_text.dart';

class CardControl extends StatelessWidget {
  final String image;
  final String text;
  final Function onTap;

  const CardControl(
      {super.key,
      required this.image,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        color: Colors.white,
        child: Container(
          width: 130,
          height: 130,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Image.asset(image),
              Expanded(
                child: AppText(
                  text: text,
                  isBold: true,
                  maxLines: 2,
                  size: 14,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
