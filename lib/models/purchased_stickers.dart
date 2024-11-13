import 'dart:convert';

List<PurchasedStickers> purchasedStickersFromJson(String str) =>
    List<PurchasedStickers>.from(
        json.decode(str).map((x) => PurchasedStickers.fromJson(x)));

String purchasedStickersToJson(List<PurchasedStickers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PurchasedStickers {
  int id;
  int stickerpackId;
  String filename;
  int position;

  PurchasedStickers({
    required this.id,
    required this.stickerpackId,
    required this.filename,
    required this.position,
  });

  factory PurchasedStickers.fromJson(Map<String, dynamic> json) =>
      PurchasedStickers(
        id: json["id"],
        stickerpackId: json["stickerpack_id"],
        filename: json["filename"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stickerpack_id": stickerpackId,
        "filename": filename,
        "position": position,
      };
}
