import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart' as bb;
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'models/stickers_model.dart';
import 'network/api_constants.dart';
import 'presentation/widgets/stickers_header_widget.dart';
import 'presentation/widgets/textwidgets.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class CameraWithStickers extends StatefulWidget {
  final String imagePath;
  const CameraWithStickers({super.key, required this.imagePath});

  @override
  State<CameraWithStickers> createState() => _CameraWithStickersState();
}

class _CameraWithStickersState extends State<CameraWithStickers> {
  List<List<Sticker>> purchasedStickers = [];
  int currentIndex = 0;
  List<Widget?> stickersWidgets = [];

  double top = 200;
  double left = 125;
  ScreenshotController screenshotController = ScreenshotController();

  bool isSharing = false;

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

  ondeleteSet(Widget wid) {
    final index = stickersWidgets.indexWhere((item) => item == wid);
    stickersWidgets[index] = null;
    if (stickersWidgets.every((element) => element == null)) {
      stickersWidgets = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getHiveData();
  }

  shareImageWithOthers(Uint8List image) async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final file = File('$path/image.png');
    file.writeAsBytes(image);

    final result = await Share.shareXFiles(
      [XFile(file.path)],
    );

    if (result.status == ShareResultStatus.dismissed) {
      isSharing = false;
      setState(() {});
    } else {
      isSharing = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        top: false,
        child: Column(
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
                  InkWell(
                    onTap: () {
                      isSharing = true;
                      setState(() {});
                      screenshotController.capture().then((Uint8List? image) {
                        shareImageWithOthers(image!);
                      });
                    },
                    child: const Icon(
                      Icons.ios_share,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Screenshot(
              controller: screenshotController,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 345,
                // color: Colors.green,
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 345,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(
                          File(widget.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                      for (var wid in stickersWidgets)
                        wid == null
                            ? Container()
                            // : TransformText(
                            //     scaleWidget: wid,
                            //   )

                            : DraggableWidget(
                                isSharing: isSharing,
                                ondeleteClik: (val) {
                                  if (val) ondeleteSet(wid);
                                },
                                child: wid,
                              )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 195,
              child: Container(child: bottomStickerView()),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomStickerView() {
    return Column(
      children: [
        if (purchasedStickers.isNotEmpty)
          SizedBox(
            height: 55,
            child: SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: purchasedStickers.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      currentIndex = index;
                      setState(() {});
                    },
                    child: StickerHeaderWidget(
                      size: 50,
                      image:
                          "${ApiConstants.baseUrlForImages}/${purchasedStickers[index].first.filename}",
                    ),
                  );
                },
              ),
            ),
          ),
        SizedBox(
            height: 2,
            child: Container(
              color: Colors.grey[400],
              height: 1,
            )),
        if (purchasedStickers.isNotEmpty)
          SizedBox(
            height: 125,
            child: SizedBox(
              height: 125,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: purchasedStickers[currentIndex].length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      stickersWidgets.add(StickerHeaderWidget(
                        size: 0,
                        image:
                            "${ApiConstants.baseUrlForImages}/${purchasedStickers[currentIndex][index].filename}",
                      ));
                      setState(() {});
                    },
                    child: StickerHeaderWidget(
                      size: 125,
                      image:
                          "${ApiConstants.baseUrlForImages}/${purchasedStickers[currentIndex][index].filename}",
                    ),
                  );
                },
              ),
            ),
          ),
        if (purchasedStickers.isEmpty)
          Center(
            child: SizedBox(
              height: 190,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/not_found.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NeoText(
                        text: "No Stickers Found .",
                        size: 16,
                        color: HexColor("#6E6E6E"),
                        fontWeight: FontWeight.w500)
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }
}

class DraggableWidget extends StatefulWidget {
  const DraggableWidget(
      {super.key,
      required this.child,
      required this.ondeleteClik,
      required this.isSharing});
  final Widget child;
  final Function(bool) ondeleteClik;
  final bool isSharing;

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 125,
    height: 125,
  );

  @override
  Widget build(BuildContext context) {
    return bb.TransformableBox(
      rect: rect,
      clampingRect: Offset.zero & MediaQuery.sizeOf(context),
      onChanged: (result, event) {
        setState(() {
          rect = result.rect;
        });
      },
      sideHandleBuilder: (
        context,
        handle,
      ) {
        return Container(
          color: Colors.transparent,
        );
      },
      handleTapSize: 10,
      cornerHandleBuilder: (
        context,
        handle,
      ) {
        return Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isSharing ? Colors.transparent : Colors.blue),
        );
      },
      contentBuilder: (context, rect, flip) {
        return DecoratedBox(
          decoration: BoxDecoration(),
          child: Stack(
            children: [
              widget.child,
              if (!widget.isSharing)
                Positioned(
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          widget.ondeleteClik(true);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor("#08D9E0")),
                            child: Icon(Icons.close_rounded)))),
            ],
          ),
        );
      },
    );
  }
}

class TransformText extends StatefulWidget {
  final Widget scaleWidget;
  const TransformText({super.key, required this.scaleWidget}); // changed

  @override
  _TransformTextState createState() => _TransformTextState();
}

class _TransformTextState extends State<TransformText> {
  double scale = 0.0;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

    return Center(
        child: MatrixGestureDetector(
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, child) {
          return Transform(
            transform: notifier.value,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 50),
                    child: Transform.scale(
                      scale:
                          1, // make this dynamic to change the scaling as in the basic demo
                      origin: Offset(0.0, 0.0),
                      child: widget.scaleWidget,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
