import 'dart:convert';

BannerModel bannerFromJson(dynamic str) => BannerModel.fromJson((str));

String bannerToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerClass banner;

  BannerModel({
    required this.banner,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        banner: BannerClass.fromJson(json["banner"]),
      );

  Map<String, dynamic> toJson() => {
        "banner": banner.toJson(),
      };
}

class BannerClass {
  int id;
  String image;
  String url;

  BannerClass({
    required this.id,
    required this.image,
    required this.url,
  });

  factory BannerClass.fromJson(Map<String, dynamic> json) => BannerClass(
        id: json["id"],
        image: json["image"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "url": url,
      };
}

List<String> keywordsModelFromJson(dynamic str) =>
    List<String>.from((str).map((x) => x));

String keywordsModelToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
