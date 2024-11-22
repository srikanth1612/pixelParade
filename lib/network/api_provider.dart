import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pixel_parade/models/banner_model.dart';
import 'package:pixel_parade/models/purchased_stickers.dart';
import 'package:pixel_parade/models/stickers_model.dart';
import 'package:pixel_parade/network/api_constants.dart';
import 'package:pixel_parade/network/logging_intercepator.dart';
import 'package:pixel_parade/network/session_manager/session_manager.dart';
import 'package:pixel_parade/utils/shareDataToiOS.dart';

class ApiProvider {
  static final ApiProvider apiProvider = ApiProvider._internal();

  factory ApiProvider() {
    return apiProvider;
  }

  ApiProvider._internal();
  final sharedStorageService = SharedStorageService();

  static BaseOptions options = BaseOptions(
    receiveTimeout: const Duration(seconds: 90),
    connectTimeout: const Duration(seconds: 90),
    baseUrl: ApiConstants.baseUrl,
  );

  Future<Options> getHeaderOptions() async {
    String jwtToken = await SessionManager.getToken() ?? "";

    debugPrint(jwtToken);
    return Options(headers: {
      "Authorization": jwtToken,
      "contentType": "application/x-www-form-urlencoded",
    }, contentType: Headers.formUrlEncodedContentType);
  }

  static final Dio _dio = Dio(options)..interceptors.add(LoggingInterceptor());

  Future<bool> createToken() async {
    try {
      Response response = await _dio.get(
        ApiConstants.token,
      );
      if (response.statusCode == 200) {
        SessionManager.setToken(response.data);
        return true;
      } else {
        debugPrint(response.data.toString());
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<BannerModel?> getBanner() async {
    try {
      Response response = await _dio.get(
        ApiConstants.banner,
      );
      if (response.statusCode == 200) {
        return bannerFromJson(response.data);
      } else {
        debugPrint(response.data.toString());
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<List<TotalStickers>?> getStickers() async {
    try {
      Options headerOptions = await getHeaderOptions();
      Response response = await _dio.get(
          ApiConstants.stickerPackagesByPage(pageNumber: 1),
          options: headerOptions);
      if (response.statusCode == 200) {
        return totalStickersFromJson(response.data);
      } else {
        debugPrint(response.data.toString());
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<List<String>?> getKeywords() async {
    try {
      Options headerOptions = await getHeaderOptions();
      Response response =
          await _dio.get(ApiConstants.keySearchWords, options: headerOptions);
      if (response.statusCode == 200) {
        return keywordsModelFromJson(response.data);
      } else {
        debugPrint(response.data.toString());
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }

  Future<bool?> saveUserEmail(String email) async {
    try {
      Options headerOptions = await getHeaderOptions();
      Response response = await _dio.post(
        ApiConstants.sendUserEmail,
        data: {"email": email},
        options: headerOptions,
      );
      if (response.statusCode == 200) {
        SessionManager.setUserEmail(email);

        return true;
      } else {
        debugPrint(response.data.toString());
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<bool?> savePurchaseData(String storeData, String id) async {
    try {
      Options headerOptions = await getHeaderOptions();
      Response response = await _dio.post(
        ApiConstants.purchaseStickerPack(id: id),
        data: {"receipt": storeData},
        options: headerOptions,
      );
      if (response.statusCode == 200) {
        getPurchasedStickers(id);
        return true;
      } else {
        debugPrint(response.data.toString());
        return false;
      }
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }

  Future<List<Sticker>?> getPurchasedStickers(String id,
      {bool requiredStorage = true}) async {
    try {
      Options headerOptions = await getHeaderOptions();
      Response response = await _dio.get(
        ApiConstants.purchasedStickers(id: id),
        options: headerOptions,
      );
      if (response.statusCode == 200) {
        if (requiredStorage) {
          await sharedStorageService.saveDataToCoreData(
              id, jsonEncode(response.data));
          await Hive.openBox('stickersBox');
          final Box stickerBox = Hive.box('stickersBox');

          List<Sticker> data =
              purchasedStickersFromJson(jsonEncode(response.data));

          stickerBox.put(id, data);
          stickerBox.close();
        }

        List<Sticker> data =
            purchasedStickersFromJson(jsonEncode(response.data));

        return data;
      } else {
        return null;
      }
    } catch (error) {
      debugPrint(error.toString());
      return null;
    }
  }
}
