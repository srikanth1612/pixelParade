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
                  if (context.read<HomeBloc>().isTextSearch)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/images/main_logo.png")),
                  SizedBox(
                    width: 5,
                  ),
                  const NeoText(
                    text: "Pixel Parade",
                    size: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, 'searchSticker',
                        arguments: 'test'),
                    child: const Icon(
                      Icons.search_sharp,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: NeoText(
                  text: "All Sticker Collections",
                  size: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if ((state is HomeLoaded)) {
                      return GridView.builder(
                          // physics:
                          //     const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          primary: true,
                          padding: EdgeInsets.only(top: 30),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 1 / 1.2,
                                  mainAxisSpacing: 0),
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
                                title: state.totalStickers[index].name,
                                noOfStrickers:
                                    state.totalStickers[index].quantity,
                                image:
                                    "${ApiConstants.baseUrlForImages}/${state.totalStickers[index].stickers[0].filename}",
                              ),
                            );
                          });
                    } else if (state is HomeKeyWordsSearchLoaded) {
                      return GridView.builder(
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
                                title: state.totalStickers[index].name,
                                noOfStrickers:
                                    state.totalStickers[index].stickers.length,
                                image:
                                    "${ApiConstants.baseUrlForImages}/${state.totalStickers[index].stickers[0].filename}",
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
