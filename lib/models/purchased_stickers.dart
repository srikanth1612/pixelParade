import 'dart:convert';

import 'stickers_model.dart';

List<Sticker> purchasedStickersFromJson(String str) =>
    List<Sticker>.from(json.decode(str).map((x) => Sticker.fromJson(x)));

String purchasedStickersToJson(List<Sticker> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
