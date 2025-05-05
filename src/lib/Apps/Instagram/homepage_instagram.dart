import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagramanalyzer/Apps/Instagram/Follower/follower_list.dart';
import 'package:instagramanalyzer/json_converter.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/post_list.dart';
import 'package:instagramanalyzer/widgets/statisctic_elements.dart';
import 'package:instagramanalyzer/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../Color/app_Colors.dart';
import 'Messages/message_list.dart';
import 'Messages/message_sender.dart';
import 'Posts/channel.dart';
import '../../Chart/chart.dart';

class HomepageInstagram extends StatefulWidget {
  const HomepageInstagram({super.key});

  @override
  State<HomepageInstagram> createState() => _HomepageInstagramState();
}

class _HomepageInstagramState extends State<HomepageInstagram> {
    int selectedyear = 2025;

  Future<String> pickFolder() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
     return selectedDirectory;
    } else {
    }
    return "";
  }

  Future<List<Map<String, dynamic>>> convertJsonFromFile({required String path, String? key}) async {
    final file = File(path);
    var list;
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = jsonDecode(contents);

      if(key != null){
        list = jsonData[key];
      }else{
        list = jsonData;
      }

      if (list is List) {
        return List<Map<String, dynamic>>.from(list);
      } else {
        throw Exception("Expected a list");
      }
    } else {
      throw Exception("File not found");
    }
  }

    bool isMobile = defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;


  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: const Color(0xFF121212),


     body: SingleChildScrollView(
         child: Column(
           spacing: 20,
           children: [


             topFollowerAndChannels(context),

             likesAndMsgCntContainer(context),

             Consumer<PostList>(
               builder: (context, postList, child){
                 DateTime curDate = DateTime.now();
                 Map<int, double> data = postList.getActivityHeatMapData(curDate.year, context);
                     return Container(
                         //height: 100,
                         width: MediaQuery.of(context).size.width * 0.95,
                         child: HeadMapActivityDay(data: data, dayDif: DateTime(curDate.year,1,1).weekday)

                     );
               },
             ),

             Consumer<MesageSenderList>(
               builder: (context, messageList, child){
                 List<double> data = messageList.getHeatMapData;

                 return Center(
                   child: Container(
                     height: 100,
                     child: HeadMapMessagesHour(data: data, width: MediaQuery.of(context).size.width * 0.9, heigth: 100, borderRadius: 6,),
                   ),
                 );
               },
             ),

             likedPostChart(context),

             followerChart(context),

             followerPieChart(context),

             likesBarChart(context),

             messagesPieChart(context),

             sentVsGotMessagesChart(context),

             mostActivChats(context),

             heatMapHours(context),

             heatMapDays(),


             ElevatedButton(
               onPressed: ()async{
                 String path = await JsonConverter.pickAndUnzipeFile();

                 await Provider.of<PostList>(context, listen: false).readPostsFromJson(path);
                 Provider.of<PostList>(context, listen: false).sortPostsToChannel();

                 await Provider.of<FollowerList>(context, listen: false).readFollowersFromJson(path);
                 await Provider.of<FollowerList>(context, listen: false).readFollowingFromJson(path);

                 await Provider.of<MesageSenderList>(context, listen: false).syncMessageSender(path);


               },

               child: Text("Pfad"),
             ),
           ],
         )
     ),


   );
  }
}
