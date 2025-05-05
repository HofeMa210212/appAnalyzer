
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/channel.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/post.dart';
import 'package:instagramanalyzer/json_converter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Messages/message.dart';
import '../Messages/message_list.dart';

class PostList extends ChangeNotifier{

List<Post> _posts = [];
List<Channel> _channels = [];

List<Post> get post{
  return _posts;
}

List<Channel> get channel{
  _channels.sort((a,b) => b.posts.length.compareTo(a.posts.length));
  return _channels;
}

String get von{
  post.sort((a,b) => a.timestamp.compareTo(b.timestamp));

  if(post.isEmpty) return "";
  DateTime date = DateTime.fromMillisecondsSinceEpoch(post[0].timestamp * 1000);

  return "${date.day}.${date.month}.${date.year}";

}

String get bis{
  post.sort((a,b) => b.timestamp.compareTo(a.timestamp));

  if(post.isEmpty) return "";
  DateTime date = DateTime.fromMillisecondsSinceEpoch(post[0].timestamp * 1000);

  return "${date.day}.${date.month}.${date.year}";

}


void add(Post p){
  _posts.add(p);
  notifyListeners();
}

List<Channel> get channelSortedByLikes{
  List<Channel> channels = _channels;
  channels.sort((a,b) => b.likedPostCnt.compareTo(a.likedPostCnt));
  return channels;

}

Future<void> readPostsFromJson(String path)async{

  List<Map<String, dynamic>> posts = await JsonConverter.convertJsonFromFile(path: "$path/your_instagram_activity/likes/liked_posts.json", key: "likes_media_likes");

  for(Map<String, dynamic> post in posts){

    Post p = new Post(title: post["title"], href: post["string_list_data"][0]["href"], timestamp: post["string_list_data"][0]["timestamp"]);

    add(p);
  }
  notifyListeners();


}

void sortPostsToChannel(){
  Set<String> channelName =  {};

  for(Channel c in _channels){
    c.likedPostCnt =0;
  }

  for(Post p in _posts){

    if(!channelName.contains(p.title)){
      Channel c = new Channel(name: p.title);
      c.addPost(p);
      _channels.add(c);
      channelName.add(p.title);
  }else{
    int index = _channels.indexOf(new Channel(name: p.title));
    _channels[index].addPost(p);

    }
  }
  notifyListeners();
}

List<FlSpot> getLikesChartData(){
  List<FlSpot> dataPoints = [];
  List<Post> posts = _posts;
  int cnt = 1;
  int firstTimestamp = 0;

  posts.sort((a, b) => a.timestamp.compareTo(b.timestamp));

  if(!posts.isEmpty) firstTimestamp = posts[0].timestamp;


  for(int i = 0; i < posts.length; i += 13){
    dataPoints.add(FlSpot(posts[i].timestamp.toDouble() - firstTimestamp, i.toDouble()));
  }


  return dataPoints;
}

Map<int, double> getActivityHeatMapData(int year, BuildContext context){
  Map<int, double> data = {};
  int length = 365;

  List<Message> messages = Provider.of<MesageSenderList>(context).message;
  List<Post> likedPosts = post.toList();

  for(Message m in messages){
    int timestamp = m.timestamp;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if(date.year == year){
      int day = _getDayOfYear(date);
      double oldData = data[day] ?? 0;
      oldData ++;
      data[day] = oldData;
    }
  }

  for(Post p in likedPosts){
    int timestamp = p.timestamp;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if(date.year == year){
      int day = _getDayOfYear(date);
      double oldData = data[day] ?? 0;
      oldData ++;
      data[day] = oldData;
    }
  }


  if((year % 4 == 0) && (year % 100 != 0 || year % 400 == 0))  length = 366;

  for(int i =0; i!= length; i++){
    data[i+1] = data[i+1] ?? 0;
  }



  return data;
}


int _getDayOfYear(DateTime date){
  return int.parse(DateFormat("D").format(date));
}

}