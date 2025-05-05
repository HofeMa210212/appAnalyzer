// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'played_song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayedSongAdapter extends TypeAdapter<PlayedSong> {
  @override
  final int typeId = 0;

  @override
  PlayedSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayedSong(
      trackName: fields[0] as String,
      artistName: fields[1] as String,
      trackId: fields[2] as String,
      msPlayedList: (fields[4] as List).cast<int>(),
      endTimes: (fields[3] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayedSong obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.trackName)
      ..writeByte(1)
      ..write(obj.artistName)
      ..writeByte(2)
      ..write(obj.trackId)
      ..writeByte(3)
      ..write(obj.endTimes)
      ..writeByte(4)
      ..write(obj.msPlayedList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayedSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
