import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';

import 'features/home_feature/bloc/bloc/home_bloc.dart';
import 'network/api_constants.dart';
import 'presentation/widgets/boxdecortion_withtext.dart';

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
                            child: TextField(
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ""),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                              onChanged: (value) {
                                context
                                    .read<HomeBloc>()
                                    .add(HomeKeywordSearchEvent(value));
                              },
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
                child: BlocBuilder<KeywordsBloc, KeywordsState>(
                  builder: (context, state) {
                    if (state is KeywordsLoaded) {
                      return SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.keywords.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                context.read<HomeBloc>().add(
                                    HomeKeywordSearchEvent(
                                        state.keywords[index]));
                              },
                              child: BoxDecorationWithCenterText(
                                  title: state.keywords[index],
                                  borderColor: HexColor("#FFE894"),
                                  color: HexColor("#FFFFEA")),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
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
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 20, 10, 10),
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                      if (state is HomeKeyWordsSearchLoaded) {
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
                            });
                      } else {
                        return Column(
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
                        );
                      }
                    }),
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
