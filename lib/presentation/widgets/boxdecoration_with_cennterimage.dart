import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class BoxDecorationWithCenterImage extends StatelessWidget {
  final String price;
  final HexColor hexColor;
  final String title;
  final int noOfStrickers;
  final String image;

  const BoxDecorationWithCenterImage({
    super.key,
    required this.price,
    required this.hexColor,
    required this.title,
    required this.noOfStrickers,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Column(
        // physics: const NeverScrollableScrollPhysics(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.width * .35,
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor("#81F0F3"), width: 1),
                  borderRadius: BorderRadius.circular(30),
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          NeoText(
              text: title,
              size: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600),
          const SizedBox(
            height: 5,
          ),
          Row(
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
        ],
      ),
    );
  }
}
