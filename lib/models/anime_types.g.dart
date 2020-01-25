// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anime_types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeTypeAdapter extends TypeAdapter<AnimeType> {
  @override
  final typeId = 2;

  @override
  AnimeType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AnimeType.TV;
      case 1:
        return AnimeType.MOVIE;
      case 2:
        return AnimeType.SPECIAL;
      case 3:
        return AnimeType.OVA;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, AnimeType obj) {
    switch (obj) {
      case AnimeType.TV:
        writer.writeByte(0);
        break;
      case AnimeType.MOVIE:
        writer.writeByte(1);
        break;
      case AnimeType.SPECIAL:
        writer.writeByte(2);
        break;
      case AnimeType.OVA:
        writer.writeByte(3);
        break;
    }
  }
}
