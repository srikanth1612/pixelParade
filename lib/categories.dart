import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/features/home_feature/bloc/bloc/home_bloc.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_withnotification.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';
import 'package:pixel_parade/subcategories.dart';

class MyCategories extends StatefulWidget {
  const MyCategories({Key? key}) : super(key: key);

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  @override
  Widget build(BuildContext context) {
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
                const NeoText(
                  text: "My Categories",
                  size: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
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
                      text: "Popular Categories (6)",
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: "These are most popular category",
                      size: 13,
                      color: HexColor("#6E6E6E"),
                      fontWeight: FontWeight.w500),
                ),
                BlocBuilder<KeywordsBloc, KeywordsState>(
                  builder: (context, state) {
                    return (state is KeywordsLoaded)
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * .34,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 1 / 1,
                                        mainAxisSpacing: 12),
                                itemCount: 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    // onTap: () => Navigator.pushNamed(
                                    //     context, 'subCategories',
                                    //     arguments: 'Free'),
                                    child: BoxDecorationWithCenterText(
                                      title: state.keywords[index],
                                      rightPadding: 4,
                                      borderColor: HexColor("#FF9494"),
                                      color: HexColor("#FFEAEA"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: "Other Categories (40)",
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: "View all updated categories",
                      size: 13,
                      color: HexColor("#6E6E6E"),
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SizedBox(
                    child: BlocBuilder<KeywordsBloc, KeywordsState>(
                      builder: (context, state) {
                        return (state is KeywordsLoaded)
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 1 / 1,
                                        mainAxisSpacing: 20),
                                itemCount: state.keywords.length - 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return BoxDecorationWithNotification(
                                    title: state.keywords[index + 6],
                                    notification: false,
                                  );
                                },
                                // children: const [
                                //   BoxDecorationWithNotification(
                                //     title: "Cheerleading",
                                //     notification: false,
                                //   ),
                                //   BoxDecorationWithNotification(
                                //     title: "Colorinng Books",
                                //     notification: false,
                                //   ),
                                //   BoxDecorationWithNotification(
                                //     title: "Digital Stickers",
                                //     notification: false,
                                //   ),
                                //   BoxDecorationWithNotification(
                                //       title: "Exclusive ArtWork", notification: false),
                                //   BoxDecorationWithNotification(
                                //       title: "Fonts", notification: false),
                                //   BoxDecorationWithNotification(
                                //       title: "Football", notification: false),
                                //   BoxDecorationWithNotification(
                                //       title: "Soccer", notification: false),
                                //   BoxDecorationWithNotification(
                                //       title: "Graduation", notification: false),
                                //   BoxDecorationWithNotification(
                                //       title: "Holidays", notification: false)
                                // ],
                              )
                            : Container();
                      },
                    ),
                  ),
                )
              ]))),
        ]));
  }
}
