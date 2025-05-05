

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagramanalyzer/Apps/Instagram/Messages/message_sender.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/channel.dart';
import 'package:instagramanalyzer/Apps/Instagram/Posts/post_list.dart';
import 'package:instagramanalyzer/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../Chart/chart.dart';
import '../Color/app_Colors.dart';
import '../Apps/Instagram/Follower/follower_list.dart';
import '../Apps/Instagram/Messages/message_list.dart';

Widget topFollowerAndChannels(BuildContext context) {

  return  Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 300,
            child: Consumer<MesageSenderList>(
              builder: (context, messageSenderList, child){
                List<MessageSender> sender = messageSenderList.sender;
                List<Color> backgroundColor = AppColors.backgroundColors;
                List<Color> textColor = AppColors.textColors;
                int length = 5;
                if(sender.length < 5) length = sender.length;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                         length,
                          (index){
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 53,
                          decoration: BoxDecoration(
                              color: AppColors.spotifyContainerColor,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 53,
                                width: 53,
                                decoration: BoxDecoration(
                                  color: backgroundColor[index].withAlpha(150),
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: FittedBox(
                                  child: Text(
                                    sender[index].name[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: textColor[1].withAlpha(150),

                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.45 - 63,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                height: 53,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 25,
                                      child: FittedBox(
                                        child: Text(
                                          sender[index].name,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      child: AutoSizeText(
                                        sender[index].messages.length.toString() + " msg.",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                        maxFontSize: 14,
                                        minFontSize: 8, // optional, damit er sich auch bei sehr wenig Platz verkleinert
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                );
              },
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: 300,
            child: Consumer<PostList>(
              builder: (context, postList, child){
                List<Channel> channel = postList.channel;
                List<Color> backgroundColor = AppColors.backgroundColors;
                backgroundColor.shuffle();
                List<Color> textColor = AppColors.textColors;
                int length = 5;
                if(channel.length < 5) length = channel.length;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                         length,
                          (index){
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: 53,
                          decoration: BoxDecoration(
                              color: AppColors.spotifyContainerColor,
                              borderRadius: BorderRadius.circular(6)
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 53,
                                width: 53,
                                decoration: BoxDecoration(
                                  color: backgroundColor[index].withAlpha(150),
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: FittedBox(
                                  child: Text(
                                    channel[index].name[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: textColor[1].withAlpha(150),

                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.45 - 63,
                                margin: EdgeInsets.only(left: 5, right: 5),
                                height: 53,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 25,
                                      child: FittedBox(
                                        child: Text(
                                          channel[index].name,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
                                            fontSize: 18
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      child: AutoSizeText(
                                        channel[index].posts.length.toString() + " likes",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                        maxFontSize: 14,
                                        minFontSize: 8, // optional, damit er sich auch bei sehr wenig Platz verkleinert
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                );
              },
            ),
          ),



        ],
      ),
    ),
  );

}

Widget likedPostChart(BuildContext context){

  return   Center(
    child: BigDataContainer(
      header: "Gelikte Posts",
      description:  Consumer<PostList>(
          builder: (context, postList, child){
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Posts: ${postList.post.length}",
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Channels: ${postList.channel.length}",
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                      "Von ${postList.von} bis ${postList.bis}",
                      style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontSize: 18,
                      )
                  )
                ]

            );
          }
      ),
      child:  Center(
        child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Consumer<PostList>(
              builder: (context, postList, child){
                List<List<FlSpot>> data = [];
                data.add(postList.getLikesChartData());

                if(data.length <=0) return Container();

                return SimpleLineChart(dataPoints: data,);
              },
            )
        ),
      ),
    ),
  );
}

Widget followerChart(BuildContext context){
  return  Center(
    child: BigDataContainer(
      header: "Follower",
      description:  Consumer<FollowerList>(
          builder: (context, followerList, child){
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Text(
                    "Follower: ${followerList.folower.length}",
                    style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                      "Erster : ${followerList.firstFollowerName} am ${followerList.firstFollowerDate}",
                      style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontSize: 18,
                      )
                  ),
                  Text(
                      "Lezter : ${followerList.lastFollowerName} am ${followerList.lastFollowerDate}",
                      style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontSize: 18,
                      )
                  ),

                ]

            );
          }
      ),
      child:  Center(
        child: Container(

            height: 300,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Consumer<FollowerList>(
              builder: (context, followerList, child){
                List<List<FlSpot>> data = [];
                data.add(followerList.getFollowerChartData());
                if(data.length <=0) return Container();
                return SimpleLineChart(dataPoints: data,);
              },
            )
        ),
      ),
    ),
  );
}

Widget followerPieChart(BuildContext context){
  return Center(
    child: SmallDataContainer(
      header: "Follower",
      description: Consumer<FollowerList>(
          builder: (context, followList, child){
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Beide: ${followList.bothFollowed}",
                    style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontSize: 14
                    ),
                  ),
                  Text(
                    "Nur du: ${followList.youFollowed}",
                    style: GoogleFonts.roboto(
                        color: Colors.white60,
                        fontSize: 14
                    ),
                  ),
                  Text(
                      "Nur der andere ${followList.otherFollowed}",
                      style: GoogleFonts.roboto(
                          color: Colors.white60,
                          fontSize: 14
                      )
                  )
                ]

            );
          }
      ),
      child: Center(
        child: Container(
          height: 150,
          width: 300,
          child: Consumer<FollowerList>(
            builder: (context, followerList, child){
              Map<String, int> data = followerList.getFollowingChartData();
              int both = data["both"]!;
              int you = data["you"]!;
              int other = data["other"]!;
              return PieChartSample2(bothFollowing: both.toDouble(), youFollowing: you.toDouble(), otherFollowing: other.toDouble(),);
            },
          ),
        ),
      ),

    ),
  );

}

Widget likesBarChart(BuildContext context){
  return Center(
    child: SmallDataContainer(
        header: "Meist gelikte Kanäle",
        description: Consumer<PostList>(
          builder: (context,postlist, child){
            List<Channel> channels = postlist.channelSortedByLikes;
            return channels.length > 1 ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  5, (index){
                return Text(
                  "${channels.elementAt(index).name}: ${channels.elementAt(index).likedPostCnt}",
                  style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 14
                  ),
                );

              }
              ),
            ) : Container();
          },
        ),
        child:  Container(
            height: 150,
            width: 300,
            child: Consumer<PostList>(
              builder: (context, postList, child) {
                List<Channel> channels = postList.channelSortedByLikes;
                int length = channels.length.clamp(0, 5); // Maximal 5, aber >= 0

                if (length < 1) return Container(); // Keine Daten = kein Chart

                List<double> data = List.generate(
                  length,
                      (index) => channels[index].likedPostCnt.toDouble() / 100,
                );
                List<String> titles = List.generate(
                  length,
                      (index) => channels[index].name,
                );

                return SimpleBarChart(data: data, titles: titles);
              },
            )
        )
    ),
  );
}

Widget messagesPieChart(BuildContext context){
  return  Center(
    child: SmallDataContainer(
        header: "Nachrichten",
        description: Consumer<MesageSenderList>(
          builder: (context,messageList, child){
            List<int> data = [messageList.sentMessages.length, messageList.gotMessages.length];
            List<String> titles = ["Gesendet", "Empfangen"];

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  data.length, (index){
                return Text(
                  "${titles.elementAt(index)}: ${data.elementAt(index)} Nachrichten",
                  style: GoogleFonts.roboto(
                      color: Colors.white60,
                      fontSize: 14
                  ),
                );

              }
              ),
            );
          },
        ),
        child:  Container(
            height: 150,
            width: 300,
            child: Consumer<MesageSenderList>(
              builder: (context, postList, child){
                int sent = postList.sentMessages.length;
                int got = postList.gotMessages.length;

                return PieChartSample2(bothFollowing: sent.toDouble(), youFollowing: got.toDouble(), otherFollowing: 0,);


              },
            )
        )
    ),
  );
}

Widget sentVsGotMessagesChart(BuildContext context){
  return  Center(
    child: BigDataContainer(
      header: "Gelikte Posts",
      description:  Consumer<MesageSenderList>(
          builder: (context, mesageList, child){
            List<String> titles = ["Gesendet", "Empfangen"];
            List<int> data = [mesageList.sentMessages.length, mesageList.gotMessages.length];

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    2, (index){
                  return  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color:  AppColors.chartColors.elementAt(index % AppColors.chartColors.length)
                            ),
                          ),
                          Text(
                            "${titles.elementAt(index)}: ${data.elementAt(index)} Nachrichten",
                            style: GoogleFonts.roboto(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),

                        ],
                      ),
                    ),
                  );

                }
                )

            );
          }
      ),
      child:  Center(
        child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Consumer<MesageSenderList>(
              builder: (context, messageList, child){
                List<List<FlSpot>> data = [];

                if(messageList.getGotMessagesChartData().length <= 0 && messageList.getSentMessagesChartData().length <=0) return Container();

                data.add(messageList.getGotMessagesChartData());
                data.add(messageList.getSentMessagesChartData());


                return SimpleLineChart(dataPoints: data, curveSmoothness: 5.0,);
              },
            )
        ),
      ),
    ),
  );

}

Widget mostActivChats(BuildContext context){
  return Center(
    child: BigDataContainer(
      header: "Nachrichten",
      description:  Consumer<MesageSenderList>(
          builder: (context, senderList, child){
            List<MessageSender> sender = senderList.sender;

            if(sender.length <=0) return Container();

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    5, (index){
                  return  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color:  AppColors.chartColors.elementAt(index % AppColors.chartColors.length)
                            ),
                          ),
                          Text(
                            "${sender.elementAt(index).name}: ${sender.elementAt(index).messages.length} Nachrichten",
                            style: GoogleFonts.roboto(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),

                        ],
                      ),
                    ),
                  );

                }
                )

            );
          }
      ),
      child:  Center(
        child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Consumer<MesageSenderList>(
              builder: (context, messageList, child){
                List<List<FlSpot>> data = [];
                data = messageList.getMostActiveMessagesChartData();

                if(data.length <=1) return Container();

                return SimpleLineChart(dataPoints: data, curveSmoothness: 0.5,);
              },
            )
        ),
      ),
    ),
  );
}

Widget heatMapHours(BuildContext context){
  return  Center(
    child: BigDataContainer(
      header: "Gesendete Nachrichten nach Uhrzeit",
      description:  Consumer<MesageSenderList>(
          builder: (context, mesageList, child){


            List<String> titles = ["Gesendet", "Empfangen"];
            List<int> data = [mesageList.sentMessages.length, mesageList.gotMessages.length];

            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    data.length, (index){
                  return  Container(
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 12,
                            width: 12,
                            margin: EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                                color:  AppColors.chartColors.elementAt(index % AppColors.chartColors.length)
                            ),
                          ),
                          Text(
                            "${titles.elementAt(index)}: ${data.elementAt(index)} Nachrichten",
                            style: GoogleFonts.roboto(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),

                        ],
                      ),
                    ),
                  );

                }
                )

            );
          }
      ),
      child:  Center(
        child: Container(
            alignment: Alignment.center,
            height: 300,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Consumer<MesageSenderList>(
              builder: (context, messageList, child){
                List<double> data = messageList.getHeatMapData;

                return Center(
                  child: Container(
                    height: 100,
                    child: HeadMapMessagesHour(data: data, width: MediaQuery.of(context).size.width * 0.9, heigth: 100, borderRadius: 6,),
                  ),
                );
              },
            )
        ),
      ),
    ),
  );
}

class heatMapDays extends StatefulWidget {
  const heatMapDays({super.key});

  @override
  State<heatMapDays> createState() => _heatMapDaysState();
}

class _heatMapDaysState extends State<heatMapDays> {
  late int selectedyear;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedyear = DateTime.now().year;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BigDataContainer(
        header: "Aktivität nach Tag",
        description:  Consumer<PostList>(
            builder: (context, postList, child){
              Map<int, double> data = postList.getActivityHeatMapData(selectedyear, context);
              List<MapEntry<int, double>> sortedEntries = data.entries.toList()..sort((a,b) => b.value.compareTo(a.value));

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                              (index){
                            DateTime date =  DateTime(selectedyear).add(Duration(days: sortedEntries.elementAt(index).key - 1));
                            return Text(
                              " ${date.day}.${date.month}.${date.year}: "  + sortedEntries.elementAt(index).value.toInt().toString() + " Interaktionen",
                              style: GoogleFonts.roboto(
                                  color: Colors.white60,
                                  fontSize: 14
                              ),
                            );
                          }

                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "Sehr wenig",
                          style: GoogleFonts.roboto(
                              color: Colors.white54,
                              fontSize: 12
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                            5,
                                (index){
                              int height = 15;
                              return Container(
                                height: height.toDouble(),
                                width: height.toDouble(),
                                margin: EdgeInsets.only(left: 2, right: 2),
                                decoration: BoxDecoration(
                                  color: Color.lerp(Colors.green[100], Colors.green[900], (index / 4 ).clamp(0, 1)),
                                ),
                              );
                            }
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Sehr viel",
                          style: GoogleFonts.roboto(
                              color: Colors.white54,
                              fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );

            }
        ),
        child:  Center(
          child: Container(
              alignment: Alignment.center,
              height: 300,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Consumer<PostList>(
                builder: (context, postList, child){
                  Map<int, double> data = postList.getActivityHeatMapData(selectedyear, context);

                  return Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  selectedyear --;
                                });
                              },
                              icon: Icon(
                                Icons.chevron_left_outlined,
                                size: 20,
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(AppColors.basicContainerColor),
                              ),
                            ),
                            Container(
                              width: 50,
                              margin: EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                selectedyear.toString(),
                                style: GoogleFonts.roboto(
                                    color: Colors.white60,
                                    fontSize: 18
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: (){
                                setState(() {
                                  selectedyear ++;
                                });
                              },
                              icon: Icon(
                                Icons.chevron_right_outlined,
                                size: 20,
                              ),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(AppColors.basicContainerColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HeadMapActivityDay(data: data, dayDif: DateTime(selectedyear,1,1).weekday),
                    ],
                  );


                },
              )
          ),
        ),
      ),
    );
  }
}

Widget likesAndMsgCntContainer(BuildContext context){
  return Container(
    width: MediaQuery.of(context).size.width * 0.8,
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<MesageSenderList>(
          builder: (context, mesageList, child){
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 45,
              decoration: BoxDecoration(
                  color: AppColors.spotifyContainerColor,
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    mesageList.message.length.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

            );
          },
        ),
        Consumer<PostList>(
          builder: (context, postList, child){
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.spotifyContainerColor,
                borderRadius: BorderRadius.circular(6)
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    postList.post.length.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

            );
          },
        ),

      ],
    ),
  );
}
