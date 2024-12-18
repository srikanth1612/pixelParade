import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';
import 'package:pixel_parade/utils/saveFilesLocally.dart';

class BoxDecorationWithText extends StatelessWidget {
  final String price;

  final String title;
  final int noOfStrickers;
  final String image;
  final bool isPriceRequired;

  const BoxDecorationWithText(
      {super.key,
      required this.price,
      required this.title,
      required this.noOfStrickers,
      required this.image,
      this.isPriceRequired = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.height * .18,
          margin: const EdgeInsets.fromLTRB(0, 10, 20, 60),
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: HexColor("#81F0F3"), width: 1),
            borderRadius: BorderRadius.circular(30),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            margin: const EdgeInsets.all(12),
            child: image.contains("http")
                ? CachedNetworkImage(
                    cacheManager: CustomCacheManager(),
                    imageUrl: image,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Container(),
                  )
                : Image.asset(image),
          ),
        ),
        if (isPriceRequired)
          Positioned(
            right: 20,
            top: 0,
            child: Container(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: price.toLowerCase() == "free"
                      ? HexColor("#2794ff")
                      : HexColor("#ffffff"),
                  border: Border.all(
                      color: price.toLowerCase() == "free"
                          ? HexColor("#ffffff")
                          : HexColor("#2794ff"),
                      width: 1),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                child: NeoText(
                    text: price.toLowerCase() == "free" ? price : "\$$price",
                    size: 12,
                    color: price.toLowerCase() == "free"
                        ? HexColor("#ffffff")
                        : HexColor("#2794ff"),
                    fontWeight: FontWeight.w600)),
          ),
        if (isPriceRequired)
          Positioned(
            left: 0,
            top: 140,
            child: NeoText(
                text: getFirstWordsFast(title, " ", 3),
                size: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500),
          ),
        if (isPriceRequired)
          Positioned(
            left: 0,
            top: 165,
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

  String getFirstWordsFast(
      String sentence, String wordSeparator, int findCount) {
    if (findCount < 1) {
      return '';
    }

    Runes spaceRunes = Runes(wordSeparator);
    Runes sentenceRunes = Runes(sentence);
    String finalString = "";

    for (int letter in sentenceRunes) {
      if (letter == spaceRunes.single) {
        findCount -= 1;
        if (findCount < 1) {
          return finalString;
        }
      }
      finalString += String.fromCharCode(letter);
    }
    return finalString;
  }
}
