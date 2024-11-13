import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/features/home_feature/UI/home.dart';
import 'package:pixel_parade/features/home_feature/bloc/bloc/home_bloc.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_with_cennterimage.dart';
import 'package:pixel_parade/presentation/widgets/boxdecortion_withtext.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

import 'network/api_constants.dart';

class MyCollection extends StatefulWidget {
  const MyCollection({super.key});

  @override
  State<StatefulWidget> createState() => _MyCollection();
}

class _MyCollection extends State<MyCollection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#FAFCFF"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              height: MediaQuery.of(context).size.height * .12,
              decoration: BoxDecoration(color: HexColor("#08D9E0")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NeoText(
                    text: "My Collections",
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
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: NeoText(
                  text: "All Collections",
                  size: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: NeoText(
                  text: "View all listed collections",
                  size: 13,
                  color: HexColor("#6E6E6E"),
                  fontWeight: FontWeight.w500),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return (state is HomeLoaded)
                        ? GridView.builder(
                            // physics:
                            //     const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    childAspectRatio: 1 / 1.2,
                                    mainAxisSpacing: 10),
                            itemCount: state.totalStickers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, 'stickersPreview',
                                    arguments: state.totalStickers[index]),
                                child: BoxDecorationWithText(
                                  price: state.totalStickers[index].price != 0
                                      ? "${state.totalStickers[index].price}"
                                      : 'Free',
                                  hexColor:
                                      state.totalStickers[index].price != 0
                                          ? HexColor("#87FFD4")
                                          : HexColor("#C1B444"),
                                  title: state.totalStickers[index].name,
                                  noOfStrickers: state
                                      .totalStickers[index].stickers.length,
                                  image:
                                      "${ApiConstants.baseUrlForImages}/${state.totalStickers[index].stickers[0].filename}",
                                ),
                              );
                            })
                        : Container();
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
