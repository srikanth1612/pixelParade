import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:pixel_parade/models/purchased_stickers.dart';
import 'package:pixel_parade/network/api_provider.dart';
import 'package:pixel_parade/presentation/widgets/alertbox_with_textfield.dart';

class BillingService {
  BillingService._();
  static BillingService get instance => _instance;
  static final BillingService _instance = BillingService._();

  final InAppPurchase _iap = InAppPurchase.instance;

  Future<void> initialize() async {
    if (!(await _iap.isAvailable())) return;
    if (Platform.isIOS) {
      final iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
  }

  Future<void> dispose() async {
    if (Platform.isIOS) {
      final iosPlatformAddition =
          _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
  }

  Future fetchProducts(BuildContext context, List<String> productIds) async {
    Set<String> ids = Set.from(productIds);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    if (response.notFoundIDs.isNotEmpty) {
      showAlertMessage(
          context, "Currently no stickers found ${productIds.first}");
      // Handle not found product IDs
    }

    makePurchase(response.productDetails.first);
  }

  // Future<void> buyNonConsumableProduct(String productId) async {
  //   try {
  //     Set<String> productIds = {productId};

  //     final ProductDetailsResponse productDetails =
  //         await _iap.queryProductDetails(productIds);
  //     if (productDetails == null) {
  //       // Product not found
  //       return;
  //     }

  //     // final PurchaseParam purchaseParam =
  //     //                      PurchaseParam(productDetails: productDetails.);
  //     // await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  //   } catch (e) {
  //     // Handle purchase error
  //     print('Failed to buy plan: $e');
  //   }
  // }

  Future<bool> makePurchase(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    final purchaseDetails =
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);

    return purchaseDetails;
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
          break;

        case PurchaseStatus.restored:
          print(purchaseDetails);
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  restorePurchasedData(PurchaseDetails product) async {
    RegExp regExp = RegExp(r'\d+');

    Iterable<Match> matches = regExp.allMatches(product.productID);

    List<String> numbers = matches.map((match) => match.group(0)!).toList();

    List<PurchasedStickers>? stickers =
        await ApiProvider.apiProvider.getPurchasedStickers(numbers.first);
  }

  // handlePurchaseUpdates1(purchaseDetailsList) async {
  //   for (int index = 0; index < purchaseDetailsList.length; index++) {
  //     var purchaseStatus = purchaseDetailsList[index].status;
  //     switch (purchaseDetailsList[index].status) {
  //       case PurchaseStatus.pending:
  //         print(' purchase is in pending ');
  //         continue;
  //       case PurchaseStatus.error:
  //         print(' purchase error ');
  //         break;
  //       case PurchaseStatus.canceled:
  //         print(' purchase cancel ');
  //         break;
  //       case PurchaseStatus.purchased:
  //         print(' purchased ');
  //         break;
  //       case PurchaseStatus.restored:
  //         print(' purchase restore ');
  //         break;
  //     }

  //     if (purchaseDetailsList[index].pendingCompletePurchase) {
  //       await _iap.completePurchase(purchaseDetailsList[index]).then((value) {
  //         if (purchaseStatus == PurchaseStatus.purchased) {
  //           //on purchase success you can call your logic and your API here.
  //         }
  //       });
  //     }
  //   }
  // }

  restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (error) {
      // restore purchase fails
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
