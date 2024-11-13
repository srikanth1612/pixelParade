import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class StickerSearch extends StatefulWidget {
  const StickerSearch({Key? key}) : super(key: key);

  @override
  State<StickerSearch> createState() => _StickerSearchState();
}

class _StickerSearchState extends State<StickerSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#08D9E0"),
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .07,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Row(
                        children: [
                          InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back_ios)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            child: const TextField(
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  InputDecoration.collapsed(hintText: ""),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(Icons.close)
                  ],
                ),
              ),
            ),
            Divider(
              color: HexColor("#C9E0FB"),
              height: 0,
              indent: 0,
              thickness: 1,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 0),
              child: SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    BoxDecorationWithCenterText(
                        title: "Free",
                        borderColor: HexColor("#FF9494"),
                        color: HexColor("#FFEAEA")),
                    const SizedBox(
                      width: 10,
                    ),
                    BoxDecorationWithCenterText(
                        title: "Christmas",
                        borderColor: HexColor("#FFE894"),
                        color: HexColor("#FFFFEA")),
                    const SizedBox(
                      width: 10,
                    ),
                    BoxDecorationWithCenterText(
                        title: "Photo Filters",
                        borderColor: HexColor("#94A5FF"),
                        color: HexColor("#EAF3FF")),
                    const SizedBox(
                      width: 10,
                    ),
                    BoxDecorationWithCenterText(
                        title: "Sports",
                        borderColor: HexColor("#FFC194"),
                        color: HexColor("#FFF4EA")),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
                color: HexColor("#C9E0FB"), height: 0, indent: 0, thickness: 1),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/search_sticker.png',
                            width: 75,
                            height: 75,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          NeoText(
                              text:
                                  "Your search results have not been found.\nPlease try a different key words.",
                              size: 16,
                              color: HexColor("#6E6E6E"),
                              fontWeight: FontWeight.w500)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
