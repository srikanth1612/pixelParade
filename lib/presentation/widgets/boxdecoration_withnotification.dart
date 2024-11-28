import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class BoxDecorationWithNotification extends StatelessWidget {
  final String title;
  final bool notification;
  const BoxDecorationWithNotification(
      {Key? key, required this.title, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * .75,
          height: 65,
          decoration: BoxDecoration(
              border: Border.all(color: HexColor("#81F0F3"), width: 1),
              borderRadius: BorderRadius.circular(20),
              shape: BoxShape.rectangle,
              color: HexColor("8af7fb")),
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0),
            child: Center(
                child: NeoText(
                    text: title,
                    size: 14,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500)),
          ),
        ),
        if (notification)
          Positioned(
            left: 10,
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                color: HexColor("#F71F87"),
                border: Border.all(color: HexColor("#F71F87"), width: 1),
                shape: BoxShape.circle,
              ),
              width: 6,
              height: 6,
            ),
          ),
      ],
    );
  }
}
