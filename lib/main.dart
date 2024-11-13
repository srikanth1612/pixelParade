import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/categories.dart';
import 'package:pixel_parade/colletions.dart';
import 'package:pixel_parade/features/home_feature/UI/home.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/splash.dart';
import 'package:pixel_parade/stickersearch.dart';
import 'package:pixel_parade/stickerspreview.dart';
import 'package:pixel_parade/subcategories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
