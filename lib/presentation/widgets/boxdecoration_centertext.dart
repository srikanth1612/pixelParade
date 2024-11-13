import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class BoxDecorationWithCenterText extends StatelessWidget {
  final String title;
  final HexColor color;
  final HexColor borderColor;
  final double rightPadding;

  const BoxDecorationWithCenterText(
      {super.key,
      required this.title,
      required this.borderColor,
      required this.color,
      this.rightPadding = 10});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(20),
          shape: BoxShape.rectangle,
        ),
        width: 100,
        height: 70,
        child: Center(
          child: NeoText(
              text: title,
              size: 14,
              color: Colors.black,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
