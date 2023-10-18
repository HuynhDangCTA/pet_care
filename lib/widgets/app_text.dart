import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final bool isBold;
  final TextOverflow overflow;
  final int maxLines;
  final TextAlign textAlign;

  const AppText(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.size = 16.0,
      this.isBold = false,
      this.overflow = TextOverflow.ellipsis,
      this.maxLines = 1, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      ),
    );
  }
}
