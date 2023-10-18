import 'package:flutter/material.dart';
import 'package:pet_care/core/colors.dart';

class AppButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final String? text;
  final double? width;
  final double? height;
  final double? fontSize;
  final Function onPressed;
  bool? isResponsive;
  final bool isShadow;
  final bool isEnable;

  AppButton(
      {super.key,
      this.backgroundColor = MyColors.primaryColor,
      this.textColor = Colors.white,
      this.text,
      this.width = 100,
      this.height = 55,
      this.fontSize = 16,
      this.isResponsive = false,
      this.isShadow = true,
      this.isEnable = true,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        width: (isResponsive == true) ? double.maxFinite : width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: backgroundColor,
            boxShadow: (isShadow && isEnable)
                ? [
                    BoxShadow(
                      color: backgroundColor!.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                    )
                  ]
                : null),
        child: Center(
          child: Text(
            '$text',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
