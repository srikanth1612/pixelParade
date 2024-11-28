import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pixel_parade/network/api_provider.dart';
import 'package:pixel_parade/utils/saveFilesLocally.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class BoxDecorationWithCenterImageSmall extends StatelessWidget {
  final String image;
  const BoxDecorationWithCenterImageSmall({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Column(
        // physics: const NeverScrollableScrollPhysics(),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.width * .25,
                  decoration: BoxDecoration(
                    border: Border.all(color: HexColor("#81F0F3"), width: 1),
                    borderRadius: BorderRadius.circular(30),
                    shape: BoxShape.rectangle,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: image.contains("http")
                        ? InkWell(
                            onTap: () async {
                              final response =
                                  await ApiProvider().getStickerDetails(image);

                              // final uri =
                              //     Uri.file(response?.absolute.path ?? "");
                              // print(uri);
                              // // Launch the messaging app with the image URI
                              // final smsUrl =
                              //     'sms:?attachment=${uri.toString()}';
                              // if (!File(uri.toFilePath()).existsSync()) {
                              //   throw Exception('$uri does not exist!');
                              // } else {
                              //   print("mothing");
                              // }
                              // if (await canLaunchUrl(Uri.parse(smsUrl))) {
                              //   await launchUrl(Uri.parse(smsUrl));
                              // } else {
                              //   throw 'Could not launch $smsUrl';
                              // }

                              final result = await Share.shareXFiles(
                                [XFile(response?.path ?? "")],
                              );

                              if (result.status == ShareResultStatus.success) {
                                print('Thank you for sharing the picture!');
                              }
                            },
                            child: CachedNetworkImage(
                              cacheManager: CustomCacheManager(),
                              imageUrl: image,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) => Container(),
                            ),
                          )
                        : Image.asset(image),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
