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
  final TextEditingController _textcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#08D9E0"),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              height: MediaQuery.of(context).size.height * .12,
              decoration: BoxDecoration(color: HexColor("#08D9E0")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                ],
              ),
            ),
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .75,
                            child: TextField(
                              controller: _textcontroller,
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
                    InkWell(
                        onTap: () {
                          if (_textcontroller.text.isNotEmpty) {
                            _textcontroller.clear();
                            context
                                .read<HomeBloc>()
                                .add(HomeKeywordSearchEvent(""));
                          }
                        },
                        child: const Icon(Icons.close))
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NeoText(
                      text: "Search Categories",
                      size: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                  InkWell(
                    onTap: () {
                      final BottomBarBloc bottombarBloc =
                          BlocProvider.of<BottomBarBloc>(context);
                      bottombarBloc.add(BottomBarUpdateCategoriesEvent());
                      Navigator.pop(context);
                    },
                    child: NeoText(
                        text: "View All",
                        size: 12,
                        color: HexColor("#006FFD"),
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
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
                                  borderColor: HexColor("#8af7fb"),
                                  color: HexColor("#8af7fb")),
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
                        return state.totalStickers.isEmpty
                            ? Column(
                                children: [
                                  Image.asset(
                                    'assets/images/not_found.png',
                                    width: 150,
                                    height: 150,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  NeoText(
                                      text: "No Results Found.",
                                      size: 16,
                                      color: HexColor("#6E6E6E"),
                                      fontWeight: FontWeight.w500)
                                ],
                              )
                            : GridView.builder(
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
                                      price: state.totalStickers[index].price !=
                                              0
                                          ? "${state.totalStickers[index].price}"
                                          : 'Free',
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
        ),
      ),
    );
  }
}
