// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watching_states.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchingStateAdapter extends TypeAdapter<WatchingState> {
  @override
  final typeId = 1;

  @override
  WatchingState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WatchingState.toWatch;
      case 1:
        return WatchingState.watching;
      case 2:
        return WatchingState.watched;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, WatchingState obj) {
    switch (obj) {
      case WatchingState.toWatch:
        writer.writeByte(0);
        break;
      case WatchingState.watching:
        writer.writeByte(1);
        break;
      case WatchingState.watched:
        writer.writeByte(2);
        break;
    }
  }
}
