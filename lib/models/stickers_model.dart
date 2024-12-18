import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'stickers_model.g.dart';

List<TotalStickers> totalStickersFromJson(dynamic str) =>
    List<TotalStickers>.from((str).map((x) => TotalStickers.fromJson(x)));

String totalStickersToJson(List<TotalStickers> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TotalStickers extends Equatable {
  int id;
  String name;
  String description;
  double price;
  List<Sticker> stickers;
  int quantity;
  int position;

  TotalStickers({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stickers,
    required this.quantity,
    required this.position,
  });

  factory TotalStickers.fromJson(Map<String, dynamic> json) => TotalStickers(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"]?.toDouble(),
        stickers: List<Sticker>.from(
            json["stickers"].map((x) => Sticker.fromJson(x))),
        quantity: json["quantity"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "stickers": List<dynamic>.from(stickers.map((x) => x.toJson())),
        "quantity": quantity,
        "position": position,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        description,
        name,
        price,
      ];
}

@HiveType(typeId: 1)
class Sticker {
  @HiveField(0)
  int id;
  @HiveField(1)
  int stickerpackId;
  @HiveField(2)
  String filename;
  @HiveField(3)
  int position;

  Sticker({
    required this.id,
    required this.stickerpackId,
    required this.filename,
    required this.position,
  });

  factory Sticker.fromJson(Map<String, dynamic> json) => Sticker(
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
