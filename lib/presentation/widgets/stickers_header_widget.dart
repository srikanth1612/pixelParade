import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';
import 'package:pixel_parade/utils/saveFilesLocally.dart';
import 'dart:math' as math;

class StickerHeaderWidget extends StatelessWidget {
  final String image;
  final double size;

  const StickerHeaderWidget({
    super.key,
    required this.image,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return size == 0
        ? image.contains("http")
            ? CachedNetworkImage(
                fit: BoxFit.cover,
                cacheManager: CustomCacheManager(),
                imageUrl: image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Container(),
              )
            : Image.asset(image)
        : SizedBox(
            width: size,
            height: size,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  child: image.contains("http")
                      ? CachedNetworkImage(
                          cacheManager: CustomCacheManager(),
                          imageUrl: image,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Container(),
                        )
                      : Image.asset(image),
                ),
                // Container(
                //   height: 4,
                //   color: Colors.green,
                // )
              ],
            ),
          );
  }
}
