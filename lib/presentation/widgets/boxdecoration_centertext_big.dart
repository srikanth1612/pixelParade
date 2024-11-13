import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class BoxdecorationWithCenterTextBig extends StatelessWidget {
  final String price;
  final HexColor hexColor;
  final String title;
  final int noOfStrickers;
  final String image;

  const BoxdecorationWithCenterTextBig(
      {Key? key,
      required this.price,
      required this.hexColor,
      required this.title,
      required this.noOfStrickers,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.height * .25,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color: HexColor("#81F0F3"), width: 1),
              borderRadius: BorderRadius.circular(30),
              shape: BoxShape.rectangle,
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                image,
                fit: BoxFit.contain,
              ),
            )),
        Positioned(
          right: 0,
          //bottom: 0,
          top: 5,
          child: Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
              decoration: BoxDecoration(
                color: hexColor,
                border: Border.all(color: hexColor, width: 1),
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
              ),
              child: NeoText(
                  text: price,
                  size: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w600)),
        ),
        Positioned(
          left: 0,
          top: 150,
          child: NeoText(
              text: title,
              size: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        Positioned(
          left: 0,
          top: 172,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: HexColor("#70E2B9"),
                  border: Border.all(color: HexColor("#70E2B9"), width: 1),
                  shape: BoxShape.circle,
                ),
                width: 6,
                height: 6,
              ),
              const SizedBox(
                width: 6,
              ),
              NeoText(
                  text: "$noOfStrickers stickers",
                  size: 13,
                  color: HexColor("#7B7B7B"),
                  fontWeight: FontWeight.w600)
            ],
          ),
        )
      ],
    );
  }
}
