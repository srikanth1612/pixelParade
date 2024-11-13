class ApiConstants {
  static final ApiConstants _apiConstants = ApiConstants._internal();

  factory ApiConstants() {
    return _apiConstants;
  }

  ApiConstants._internal();

  // live

  static String baseUrl = "http://104.236.79.232/api/";
  static String baseUrlForImages = "http://104.236.79.232";

  // endpoints
  static String token = "token/create";
  static String banner = "banner";
  static String keySearchWords = "key-search-words";
  static String stickerPackagesByPage({required int pageNumber}) =>
      "sticker-pack/?page=$pageNumber";
  static String stickerPack = "sticker-pack/";

  // user related apis

  static String sendUserEmail = "email";
  static String purchaseStickerPack({required String id}) =>
      "sticker-pack/$id/purchase";
  static String purchasedStickers({required String id}) => "sticker-pack/$id";
}
