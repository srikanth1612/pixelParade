import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pixel_parade/categories.dart';
import 'package:pixel_parade/colletions.dart';
import 'package:pixel_parade/features/home_feature/UI/home.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/splash.dart';
import 'package:pixel_parade/stickersearch.dart';
import 'package:pixel_parade/stickerspreview.dart';
import 'package:pixel_parade/subcategories.dart';

import 'features/home_feature/bloc/bloc/home_bloc.dart';

void main() {
  runHive();
  runApp(MyApp());
}

runHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(StickerAdapter());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.

  final homeBloc = HomeBloc();
  final bannerBloc = BannerBloc();
  final keywordsBloc = KeywordsBloc();
  final bottombarBloc = BottomBarBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => homeBloc,
          ),
          BlocProvider<BannerBloc>(
            create: (context) => bannerBloc,
          ),
          BlocProvider<KeywordsBloc>(
            create: (context) => keywordsBloc,
          ),
          BlocProvider<BottomBarBloc>(
            create: (context) => bottombarBloc,
          ),
        ],
        child: MaterialApp(
          routes: {
            'homeScreen': (context) => HomeScreen(),
            'categories': (context) => MyCategories(),
            'collections': (context) => MyCollection(),
            'subCategories': (context) => SubCategories(),
            'searchSticker': (context) => StickerSearch(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == "stickersPreview") {
              final TotalStickers args = settings.arguments as TotalStickers;
              return MaterialPageRoute(
                builder: (context) {
                  return StickerPreview(
                    selectedSticker: args,
                  );
                },
              );
            }
            return null;
          },
          title: 'Pixel Parade',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: HexColor("#08D9E0"),
            //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
