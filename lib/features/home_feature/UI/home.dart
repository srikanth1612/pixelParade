import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pixel_parade/features/home_feature/bloc/bloc/home_bloc.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/network/api_constants.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_centertext.dart';
import 'package:pixel_parade/presentation/widgets/boxdecortion_withtext.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/utils/saveFilesLocally.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#FAFCFF"), body: homeWithStickersUI());
  }

  List<List<Sticker>> purchasedStickers = [];

  getHiveData() async {
    await Hive.openBox('stickersBox');
    final Box stickerBox = Hive.box('stickersBox');

    var allPersons = stickerBox.values.toList();

    stickerBox.close();

    purchasedStickers = [];

    for (var sticker in allPersons) {
      if (sticker.isNotEmpty) {
        List<Sticker> individualStickers = [];
        for (Sticker sti in sticker) {
          individualStickers.add(sti);
        }
        purchasedStickers.add(individualStickers);
      }
    }
    setState(() {});
  }

  Widget homeWithStickersUI() {
    return VisibilityDetector(
        key: Key('my-widget-key'),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage > 30) {
            getHiveData();
            context.read<HomeBloc>().add(HomeReload());
          }
        },
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              height: MediaQuery.of(context).size.height * .12,
              decoration: BoxDecoration(color: HexColor("#08D9E0")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const NeoText(
                    text: "Home",
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
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 148,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20),
                    //   child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Container(
                    //             width: MediaQuery.of(context).size.height * .08,
                    //             height:
                    //                 MediaQuery.of(context).size.height * .08,
                    //             decoration: BoxDecoration(
                    //                 border:
                    //                     Border.all(color: HexColor("#006FFD")),
                    //                 color: HexColor("#006FFD"),
                    //                 borderRadius: const BorderRadius.all(
                    //                     Radius.circular(20))),
                    //             child: Container(
                    //               margin: const EdgeInsets.all(12),
                    //               width: 20,
                    //               height: 20,
                    //               child: Image.asset(
                    //                 'assets/images/camera_icon.png',
                    //               ),
                    //             )),
                    //         const SizedBox(
                    //           width: 12,
                    //         ),
                    //         Flexible(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               NeoText(
                    //                   text: 'Customise your design',
                    //                   size: 16,
                    //                   color: HexColor("#006FFD"),
                    //                   fontWeight: FontWeight.w500),
                    //               const SizedBox(
                    //                 height: 5,
                    //               ),
                    //               NeoText(
                    //                   text:
                    //                       'By using your camera you can customise sticker',
                    //                   size: 14,
                    //                   color: HexColor("#436692"),
                    //                   fontWeight: FontWeight.w500)
                    //             ],
                    //           ),
                    //         )
                    //       ]),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: HexColor("#C9E0FB"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<BannerBloc, BannerState>(
                            builder: (context, state) {
                              if (state is BannerLoaded) {
                                return CachedNetworkImage(
                                  cacheManager: CustomCacheManager(),
                                  imageUrl: ApiConstants.baseUrlForImages +
                                      state.bannerData.banner.image,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Container(),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const NeoText(
                                  text: "Newly Added",
                                  size: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              InkWell(
                                onTap: () {
                                  final BottomBarBloc bottombarBloc =
                                      BlocProvider.of<BottomBarBloc>(context);
                                  bottombarBloc
                                      .add(BottomBarUpdateCollectionEvent());
                                },
                                child: NeoText(
                                    text: "View All",
                                    size: 12,
                                    color: HexColor("#006FFD"),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          NeoText(
                              text: "View all newly added Stickers",
                              size: 13,
                              color: HexColor("#6E6E6E"),
                              fontWeight: FontWeight.w500),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (previous, current) {
                              if (current is HomeLoaded) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              if (state is HomeLoaded) {
                                return SizedBox(
                                  height: 200,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.totalStickers.length > 3
                                        ? 3
                                        : state.totalStickers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () => Navigator.pushNamed(
                                            context, 'stickersPreview',
                                            arguments:
                                                state.totalStickers[index]),
                                        child: BoxDecorationWithText(
                                          price: state.totalStickers[index]
                                                      .price !=
                                                  0
                                              ? "${state.totalStickers[index].price}"
                                              : 'Free',
                                          hexColor: state.totalStickers[index]
                                                      .price !=
                                                  0
                                              ? HexColor("#87FFD4")
                                              : HexColor("#C1B444"),
                                          title:
                                              state.totalStickers[index].name,
                                          noOfStrickers: state
                                              .totalStickers[index]
                                              .stickers
                                              .length,
                                          image:
                                              "${ApiConstants.baseUrlForImages}/${state.totalStickers[index].stickers[0].filename}",
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const NeoText(
                                  text: "Popluar Categories",
                                  size: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              InkWell(
                                onTap: () {
                                  final BottomBarBloc bottombarBloc =
                                      BlocProvider.of<BottomBarBloc>(context);
                                  bottombarBloc
                                      .add(BottomBarUpdateCategoriesEvent());
                                },
                                child: NeoText(
                                    text: "View All",
                                    size: 12,
                                    color: HexColor("#006FFD"),
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          NeoText(
                              text: "View all latest popular categories",
                              size: 13,
                              color: HexColor("#6E6E6E"),
                              fontWeight: FontWeight.w500),
                          const SizedBox(
                            height: 20,
                          ),
                          BlocBuilder<KeywordsBloc, KeywordsState>(
                            builder: (context, state) {
                              if (state is KeywordsLoaded) {
                                return SizedBox(
                                  height: 70,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.keywords.length > 4
                                        ? 4
                                        : state.keywords.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          context.read<HomeBloc>().add(
                                              HomeKeywordSearchEvent(
                                                  state.keywords[index]));

                                          Navigator.pushNamed(
                                              context, 'collections',
                                              arguments: 'test');
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
                          // SizedBox(
                          //   height: 70,
                          //   child: ListView(
                          //     scrollDirection: Axis.horizontal,
                          //     children: [
                          //       BoxDecorationWithCenterText(
                          //           title: "Free",
                          //           borderColor: HexColor("#FF9494"),
                          //           color: HexColor("#FFEAEA")),
                          //       const SizedBox(
                          //         width: 10,
                          //       ),
                          //       BoxDecorationWithCenterText(
                          //           title: "Christmas",
                          //           borderColor: HexColor("#FFE894"),
                          //           color: HexColor("#FFFFEA")),
                          //       const SizedBox(
                          //         width: 10,
                          //       ),
                          //       BoxDecorationWithCenterText(
                          //           title: "Photo Filters",
                          //           borderColor: HexColor("#94A5FF"),
                          //           color: HexColor("#EAF3FF")),
                          //       const SizedBox(
                          //         width: 10,
                          //       ),
                          //       BoxDecorationWithCenterText(
                          //           title: "Sports",
                          //           borderColor: HexColor("#FFC194"),
                          //           color: HexColor("#FFF4EA")),
                          //       const SizedBox(
                          //         width: 10,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (purchasedStickers.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const NeoText(
                                    text: "Purchased",
                                    size: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (purchasedStickers.isNotEmpty)
                            NeoText(
                                text: "View all recently purchased",
                                size: 13,
                                color: HexColor("#6E6E6E"),
                                fontWeight: FontWeight.w500),
                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: purchasedStickers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    TotalStickers sticker = context
                                        .read<HomeBloc>()
                                        .totalStickersEmbedded
                                        .firstWhere((sti) =>
                                            sti.id ==
                                            purchasedStickers[index]
                                                .first
                                                .stickerpackId);

                                    Navigator.pushNamed(
                                        context, 'stickersPreview',
                                        arguments: sticker);
                                  },
                                  child: BoxDecorationWithText(
                                    price: "0",
                                    hexColor: HexColor("#C1B444"),
                                    isPriceRequired: false,
                                    title:
                                        purchasedStickers[index].first.filename,
                                    noOfStrickers: 7,
                                    image:
                                        "${ApiConstants.baseUrlForImages}/${purchasedStickers[index].first.filename}",
                                  ),
                                );
                              },
                            ),
                          ),
                          // BlocBuilder<HomeBloc, HomeState>(
                          //   builder: (context, state) {
                          //     if (state is HomeLoaded) {
                          //       return SizedBox(
                          //         height: 200,
                          //         child: ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: state.totalStickers.length > 3
                          //               ? 3
                          //               : state.totalStickers.length,
                          //           itemBuilder:
                          //               (BuildContext context, int index) {
                          //             return BoxDecorationWithText(
                          //               price: state.totalStickers[index]
                          //                           .price !=
                          //                       0
                          //                   ? "${state.totalStickers[index].price}"
                          //                   : 'Free',
                          //               hexColor:
                          //                   state.totalStickers[index].price !=
                          //                           0
                          //                       ? HexColor("#87FFD4")
                          //                       : HexColor("#C1B444"),
                          //               title: state.totalStickers[index].name,
                          //               noOfStrickers: state
                          //                   .totalStickers[index]
                          //                   .stickers
                          //                   .length,
                          //               image:
                          //                   "${ApiConstants.baseUrlForImages}/${state.totalStickers[index].stickers[0].filename}",
                          //             );
                          //           },
                          //         ),
                          //       );
                          //     } else {
                          //       return Container();
                          //     }
                          //   },
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ));
  }
}
