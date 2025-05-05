
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../spotify_auth.dart';
import 'package:http/http.dart' as http;

part 'played_song.g.dart';

@HiveType(typeId: 0)
class PlayedSong extends HiveObject{
  @HiveField(0)
  final String trackName;

  @HiveField(1)
  final String artistName;

  @HiveField(2)
  final String trackId;

  @HiveField(3)
   List<DateTime> endTimes = [];

  @HiveField(4)
   List<int> msPlayedList = [];



  PlayedSong({
    required this.trackName,
    required this.artistName,
    required this.trackId,

    List<int>? msPlayedList, // Allow null so we can assign default
    List<DateTime>? endTimes, // Allow null so we can assign default
  })  : msPlayedList = msPlayedList ?? <int>[],
        endTimes = endTimes ?? <DateTime>[];


  void addPlay(DateTime endTime, int msPlayed) {
    endTimes.add(endTime);
    msPlayedList.add(msPlayed);
  }

  int get totalTime{
    int time = 0;

    for(int t in msPlayedList){
      time += t;
    }
    return time;

  }

  Future<String?> get coverPicUrl async{
    await SpotifyAuth().fetchAccessToken();
    String? token = SpotifyAuth().accessToken;

    String id = trackId.split(":").last;

    if (token == null) {
      print('Kein Access Token verfügbar.');
      return null;
    }

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final images = data['album']['images'];

      if (images != null && images.isNotEmpty) {
        return images[0]['url'];
      }
    } else {
      print('Fehler beim Laden des Tracks: ${response.body}');
    }

    return "";
  }



}