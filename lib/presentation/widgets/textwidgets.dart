import 'package:flutter/material.dart';

class NeoText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const NeoText(
      {super.key,
      required this.text,
      required this.size,
      required this.color,
      required this.fontWeight,
      this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: size,
          fontFamily: "Inter",
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }
}
