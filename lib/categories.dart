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
                BlocBuilder<KeywordsBloc, KeywordsState>(
                  builder: (context, state) {
                    return (state is KeywordsLoaded)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 35),
                            child: SizedBox(
                              height: 280,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: true,
                                padding: EdgeInsets.all(0),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 20,
                                        childAspectRatio: 1 / 1,
                                        mainAxisSpacing: 12),
                                itemCount: 6,
                                itemBuilder: (BuildContext context, int index) {
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
                                      rightPadding: 4,
                                      borderColor: HexColor("#ffffff"),
                                      color: HexColor("#8af7fb"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
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
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SizedBox(
                    child: BlocBuilder<KeywordsBloc, KeywordsState>(
                      builder: (context, state) {
                        return (state is KeywordsLoaded)
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                primary: true,
                                padding: EdgeInsets.all(0),
                                itemCount: state.keywords.length - 6,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                          HomeKeywordSearchEvent(
                                              state.keywords[index + 6]));

                                      Navigator.pushNamed(
                                          context, 'collections',
                                          arguments: 'test');
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: BoxDecorationWithNotification(
                                          title: state.keywords[index + 6],
                                          notification: false,
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
