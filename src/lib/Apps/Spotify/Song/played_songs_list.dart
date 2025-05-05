
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:instagramanalyzer/Apps/Spotify/Song/played_song.dart';
import 'package:instagramanalyzer/Apps/Spotify/Song/singleSong.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../../json_converter.dart';
import '../spotify_auth.dart';

class PlayedSongsList extends ChangeNotifier{

  List<PlayedSong> _playedSongs = [];

  List<PlayedSong> get playedSongs{
    _playedSongs.sort((a,b) => b.msPlayedList.length.compareTo(a.msPlayedList.length));
    return _playedSongs;
  }
  
  List<SingleSong> get allPlayedSongs{
    List<SingleSong> songs = [];
    
    for(PlayedSong ps in _playedSongs){
      
      for(int i =0; i!= ps.msPlayedList.length; i++){
        SingleSong s = SingleSong(artistName: ps.artistName, trackName: ps.trackName, endTime: ps.endTimes[i], msPlayed: ps.msPlayedList[i]);
        songs.add(s);
      }
    } 
    
    return songs;
  }

  int get timeInMinutes{
    int time = 0;

    for(PlayedSong ps in _playedSongs){
      time += ps.totalTime;
    }

    return time ~/ 60000;

  }

  void getPlayedSongsFromJson(String path) async {
    String pattern = r'^Streaming_History_(Audio|Video)_(\d{4})-(\d{4})(?:_\d+)?\.json$';
    List<String> songPaths = await JsonConverter.searchFile(path, pattern,);

    Map<String, PlayedSong> songMap = {}; // key = trackName + artistName

    for (String songPath in songPaths) {
      List<Map<String, dynamic>> songs = await JsonConverter.convertJsonFromFile(path: songPath);

      for (Map<String, dynamic> song in songs) {
        String trackName = song["master_metadata_track_name"] ?? "";
        String artistName = song["master_metadata_album_artist_name"] ?? "";
        DateTime endTime = DateTime.parse(song["ts"]);
        int msPlayed = song["ms_played"];
        String trackId = song["spotify_track_uri"] ?? "";

        String key = "$trackName|$artistName";

        if (!songMap.containsKey(key)) {
          songMap[key] = PlayedSong(trackName: trackName, artistName: artistName, trackId: trackId);
        }

        songMap[key]!.addPlay(endTime, msPlayed);
      }
    }

    _playedSongs.clear();
    _playedSongs.addAll(songMap.values);

    notifyListeners();

   save();

  }

  Future<List<Map<String, dynamic>>> _fetchMultipleTracks(List<String> ids) async {
    await SpotifyAuth().fetchAccessToken();
    String? token = SpotifyAuth().accessToken;
    final joinedIds = ids.join(',');
    final url = Uri.parse('https://api.spotify.com/v1/tracks?ids=$joinedIds');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['tracks']);
    } else {
      throw Exception('Fehler beim Laden der Tracks: ${response.body}');
    }
  }

  Future<List<String>> mostPlayedCovers()async{
    List<String> ids = [];
    List<String> urls = [];

    for(int i =0; i!= 50; i++){
      String id = _playedSongs[i].trackId.split(":").last;
      ids.add(id);
    }

    final tracks = await _fetchMultipleTracks(ids);
    for (var track in tracks) {
      urls.add(track['album']['images'][0]['url']);
    }
    return urls;
  }

  List<FlSpot> getSongChartData(){
    List<FlSpot> dataPoints = [];
    List<SingleSong> songs = allPlayedSongs;
    int firstTimestamp = 0;
    List<int> data = List.filled(12, 0);

    for(SingleSong s in songs){
      data[s.endTime.month-1] ++;
    }



    for(int i =0; i!= 12; i +=2){
      data[i] += data[i+1];
      dataPoints.add(FlSpot(i.toDouble(),data[i].toDouble() ));
    }


    print(dataPoints);

    return dataPoints;
  }





  void save(){
    var box = Hive.box<PlayedSong>('songsBox');

    box.clear();

    for(PlayedSong ps in _playedSongs){
      box.add(ps);
    }

  }

  void read(){
    var box = Hive.box<PlayedSong>('songsBox');
    List<PlayedSong> allSongs = box.values.toList();

    _playedSongs.clear();

    for(PlayedSong ps in allSongs){
      print("Song: ${ps.trackName} hinzugefügt");
      _playedSongs.add(ps);
    }

    notifyListeners();

  }


}