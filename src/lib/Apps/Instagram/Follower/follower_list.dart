
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramanalyzer/Apps/Instagram/Follower/follower.dart';
import 'package:instagramanalyzer/json_converter.dart';

class FollowerList extends ChangeNotifier{
  List<Follower> _followers = [];
  List<Follower> _following = [];



  List<Follower> get folower{
    return _followers;
  }
  
  List<Follower> get following{
    return _following;
  }
  
  void addFollowing(Follower f){
    _following.add(f);
  }

  void addFollower(Follower f ){
    _followers.add(f);
  }

  String get firstFollowerDate{
    List<Follower> follower = _followers;

    follower.sort((a,b) => a.timestamp.compareTo(b.timestamp));
    if(follower.isEmpty) return "";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(follower[0].timestamp * 1000);

    return "${date.day}.${date.month}.${date.year}";

  }

  String get lastFollowerDate{
    List<Follower> follower = _followers;

    follower.sort((a,b) => b.timestamp.compareTo(a.timestamp));
    if(follower.isEmpty) return "";
    DateTime date = DateTime.fromMillisecondsSinceEpoch(follower[0].timestamp * 1000);

    return "${date.day}.${date.month}.${date.year}";

  }

  String get lastFollowerName{
    List<Follower> follower = _followers;

    follower.sort((a,b) => b.timestamp.compareTo(a.timestamp));
    if(follower.isEmpty) return "";
    return follower[0].name;

  }

  String get firstFollowerName{
    List<Follower> follower = _followers;

    follower.sort((a,b) => a.timestamp.compareTo(b.timestamp));
    if(follower.isEmpty) return "";
    return follower[0].name;

  }

  int get bothFollowed{

    final follower = _followers.map((f) => f.name).toSet();
    final following = _following.map((f) => f.name).toSet();

    return following.intersection(follower).length;
  }

  int get youFollowed{

    final follower = _followers.map((f) => f.name).toSet();
    final following = _following.map((f) => f.name).toSet();

    return following.difference(follower).length;
  }

  int get otherFollowed{
    final follower = _followers.map((f) => f.name).toSet();
    final following = _following.map((f) => f.name).toSet();

    return follower.difference(following).length;

  }


  Future<void> readFollowersFromJson(String path)async{

    List<Map<String, dynamic>> followers = await JsonConverter.convertJsonFromFile(path: "$path/connections/followers_and_following/followers_1.json");

   for (Map<String, dynamic> follower in followers) {
     Follower f =  Follower(name: follower["string_list_data"][0]["value"], timestamp: follower["string_list_data"][0]["timestamp"], href: follower["string_list_data"][0]["href"]);
      addFollower(f);
   }



   notifyListeners();

  }

  Future<void> readFollowingFromJson(String path)async{

    List<Map<String, dynamic>> following = await JsonConverter.convertJsonFromFile(path: "$path/connections/followers_and_following/following.json", key: "relationships_following");

    for (Map<String, dynamic> follower in following) {
      Follower f =  Follower(name: follower["string_list_data"][0]["value"], timestamp: follower["string_list_data"][0]["timestamp"], href: follower["string_list_data"][0]["href"]);
      addFollowing(f);
    }

    notifyListeners();

  }

  List<FlSpot> getFollowerChartData(){
    List<FlSpot> dataPoints = [];
    List<Follower> follower = _followers;
    int firstTimestamp = 0;

    follower.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if(!follower.isEmpty) firstTimestamp = follower[0].timestamp;


    for(int i = 0; i < follower.length; i += 1){
      dataPoints.add(FlSpot(follower[i].timestamp.toDouble() - firstTimestamp, i.toDouble()));
    }


    return dataPoints;
  }

  Map<String, int> getFollowingChartData() {
    final follower = _followers.map((f) => f.name).toSet();
    final following = _following.map((f) => f.name).toSet();

    final both = following.intersection(follower).length;
    final you = following.difference(follower).length;
    final other = follower.difference(following).length;

    return {
      "both": both,
      "you": you,
      "other": other,
    };
  }


}