// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimeAdapter extends TypeAdapter<Anime> {
  @override
  final typeId = 0;

  @override
  Anime read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Anime(
      id: fields[0] as int,
      slug: fields[2] as String,
      name: fields[1] as String,
      cover: fields[3] as Uint8List,
      banner: fields[7] as Uint8List,
      favorite: fields[4] as bool,
      watchingState: fields[5] as WatchingState,
      episodesSeen: (fields[6] as List)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Anime obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.cover)
      ..writeByte(7)
      ..write(obj.banner)
      ..writeByte(4)
      ..write(obj.favorite)
      ..writeByte(5)
      ..write(obj.watchingState)
      ..writeByte(6)
      ..write(obj.episodesSeen);
  }
}
