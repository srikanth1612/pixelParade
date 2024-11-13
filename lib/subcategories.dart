import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext_big.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_with_cennterimage.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_withnotification.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

class SubCategories extends StatefulWidget {
  const SubCategories({Key? key}) : super(key: key);

  @override
  State<SubCategories> createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  @override
  void initState() {
    super.initState();
    //print(ModalRoute.of(context)?.settings.arguments);
  }

  @override
  Widget build(BuildContext context) {
    String title = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
        backgroundColor: HexColor("#FAFCFF"),
        body: Column(children: [
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            height: MediaQuery.of(context).size.height * .12,
            decoration: BoxDecoration(color: HexColor("#08D9E0")),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                    ),
                    NeoText(
                      text: title,
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, 'searchSticker',
                      arguments: 'test'),
                  child: const Icon(
                    Icons.search_sharp,
                    size: 30,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: "Sticker Packs (6)",
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: "Praesent molestie nec dolor vitae dignissim.",
                      size: 13,
                      color: HexColor("#6E6E6E"),
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * .12,
                    child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              childAspectRatio: 1 / 1.2,
                              mainAxisSpacing: 10),
                      children: [
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'New Years Eve'),
                          child: BoxdecorationWithCenterTextBig(
                            price: 'Free',
                            hexColor: HexColor("#C1B444"),
                            title: 'New Years Eve',
                            noOfStrickers: 9,
                            image: 'assets/images/sticker1.png',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'Good Christmas'),
                          child: BoxdecorationWithCenterTextBig(
                            price: '\$0.99',
                            hexColor: HexColor("#87FFD4"),
                            title: 'Good Christmas',
                            noOfStrickers: 91,
                            image: 'assets/images/sticker2.png',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'Holiday Baloons'),
                          child: BoxdecorationWithCenterTextBig(
                            price: 'Free',
                            hexColor: HexColor("#C1B444"),
                            title: 'Holiday Baloons',
                            noOfStrickers: 46,
                            image: 'assets/images/sticker3.png',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'New Years Eve'),
                          child: BoxdecorationWithCenterTextBig(
                            price: 'Free',
                            hexColor: HexColor("#C1B444"),
                            title: 'New Years Eve',
                            noOfStrickers: 9,
                            image: 'assets/images/sticker4.png',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'Good Christmas'),
                          child: BoxdecorationWithCenterTextBig(
                            price: '\$0.99',
                            hexColor: HexColor("#87FFD4"),
                            title: 'Good Christmas',
                            noOfStrickers: 91,
                            image: 'assets/images/sticker5.png',
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, 'stickersPreview',
                              arguments: 'Free'),
                          child: BoxdecorationWithCenterTextBig(
                            price: 'Free',
                            hexColor: HexColor("#C1B444"),
                            title: 'Holiday Baloons',
                            noOfStrickers: 46,
                            image: 'assets/images/sticker6.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]))),
        ]));
  }
}
