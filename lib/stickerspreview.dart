import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pixel_parade/features/purchases/purchaseHelper.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/network/api_constants.dart';
import 'package:pixel_parade/network/api_provider.dart';
import 'package:pixel_parade/network/session_manager/session_manager.dart';
import 'package:pixel_parade/presentation/widgets/alertbox_with_textfield.dart';
import 'package:pixel_parade/presentation/widgets/boxdecoration_with_centerimage_small.dart';
import 'package:pixel_parade/presentation/widgets/textwidgets.dart';
import 'package:pixel_parade/utils/shareDataToiOS.dart';

class StickerPreview extends StatefulWidget {
  final TotalStickers? selectedSticker;
  const StickerPreview({Key? key, required this.selectedSticker})
      : super(key: key);

  @override
  State<StickerPreview> createState() => _StickerPreviewState();
}

class _StickerPreviewState extends State<StickerPreview> {
  late final StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  bool isPurchased = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _purchasesSubscription = InAppPurchase.instance.purchaseStream
        .listen(handlePurchaseUpdates, onError: (error) {
      print("error");
      // handle error
    }, onDone: () {
      _purchasesSubscription.cancel();
      checkingExistingStickers();
    });
    checkingExistingStickers();
  }

  Future<void> handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // handle pending case and update the UI
          continue;
        case PurchaseStatus.error:
          // handle error case and update the UI
          break;
        case PurchaseStatus.canceled:
          // handle canceled case and update the UI
          break;
        case PurchaseStatus.purchased:
          RegExp regExp = RegExp(r'\d+');

          Iterable<Match> matches =
              regExp.allMatches(purchaseDetails.productID);

          List<String> numbers =
              matches.map((match) => match.group(0)!).toList();

          ApiProvider.apiProvider.savePurchaseData(
              purchaseDetails.verificationData.localVerificationData,
              numbers.first);
          Future.delayed(const Duration(seconds: 3), () {
            checkingExistingStickers();
          });

          break;

        case PurchaseStatus.restored:
          print(purchaseDetails);
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await BillingService.instance.iap.completePurchase(purchaseDetails);
      }
    }
  }

  checkingExistingStickers() async {
    var posts = await ApiProvider.apiProvider.getPurchasedStickers(
        widget.selectedSticker!.id.toString(),
        requiredStorage: false);

    if (posts != null) {
      widget.selectedSticker!.stickers = posts;
      isPurchased = true;
      setState(() {});
    }
  }

  final sharedStorageService = SharedStorageService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _purchasesSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#FAFCFF"),
        body: (widget.selectedSticker != null)
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  height: MediaQuery.of(context).size.height * .12,
                  decoration: BoxDecoration(color: HexColor("#08D9E0")),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                          ),
                          NeoText(
                            text: widget.selectedSticker?.name ?? "",
                            size: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, 'searchSticker',
                            arguments: 'test'),
                        child: const Icon(
                          Icons.search_sharp,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text:
                          "Stickers (${widget.selectedSticker?.stickers.length})",
                      size: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: NeoText(
                      text: widget.selectedSticker?.description ?? "",
                      size: 13,
                      color: HexColor("#6E6E6E"),
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: GridView.builder(
                          shrinkWrap: true,
                          primary: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 1 / 1.2,
                                  mainAxisSpacing: 10),
                          itemCount:
                              widget.selectedSticker?.stickers.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return BoxDecorationWithCenterImageSmall(
                              image:
                                  "${ApiConstants.baseUrlForImages}/${widget.selectedSticker?.stickers[index].filename ?? ""}",
                            );
                          },
                        ))),
                if (!isPurchased)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor("#006FFD"),
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          if (await SessionManager.getUserEmail() == "") {
                            if (mounted) {
                              showAlertWithDialouge(context, "", (message) {
                                Navigator.pop(context);
                                ApiProvider.apiProvider
                                    .saveUserEmail(message)
                                    .then((value) {
                                  if (value ?? false) {
                                    BillingService.instance.fetchProducts(
                                        context, [
                                      "io.GoodIdeas.Pixel_Parade.stickerpacks_${widget.selectedSticker?.id ?? ""}"
                                    ]);
                                  }
                                });
                              });
                            }
                          } else {
                            BillingService.instance.fetchProducts(context, [
                              "io.GoodIdeas.Pixel_Parade.stickerpacks_${widget.selectedSticker?.id ?? ""}"
                            ]);
                          }

                          // ProductDetails product = ProductDetails(
                          //     id: "163",
                          //     title: "New Years Eve",
                          //     description: "#holidays #NewYear #FREE",
                          //     price: "0",
                          //     rawPrice: 0.0,
                          //     currencyCode: "IN");

                          // // BillingService.instance.makePurchase(product);
                        },
                        child: NeoText(
                            text:
                                "\$${widget.selectedSticker?.price} | Buy Now",
                            size: 14,
                            color: HexColor("#ffffff"),
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                )
              ])
            : Container());
  }
}
