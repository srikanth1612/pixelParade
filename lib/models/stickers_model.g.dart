// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stickers_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerAdapter extends TypeAdapter<Sticker> {
  @override
  final int typeId = 1;

  @override
  Sticker read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sticker(
      id: fields[0] as int,
      stickerpackId: fields[1] as int,
      filename: fields[2] as String,
      position: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Sticker obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stickerpackId)
      ..writeByte(2)
      ..write(obj.filename)
      ..writeByte(3)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
