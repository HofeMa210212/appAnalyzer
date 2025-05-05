
import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramanalyzer/Apps/Instagram/Messages/message_sender.dart';
import 'package:path/path.dart' as p;

import 'message.dart';

class MesageSenderList extends ChangeNotifier{
  List<MessageSender> _messageSender = [];

  List<MessageSender> get messageSender{
    _messageSender.sort((a, b) => (b.gotMessage.length + b.sentMessage.length).compareTo(a.sentMessage.length + a.gotMessage.length));
    return _messageSender;
  }

  List<Message> get sentMessages{
    List<Message> messages = [];

    for(MessageSender ms in _messageSender){
      messages.addAll(ms.sentMessage);
    }
    return messages;

  }

  List<Message> get gotMessages{
    List<Message> messages = [];

    for(MessageSender ms in _messageSender){
      messages.addAll(ms.gotMessage);
    }
    return messages;
  }

  List<Message> get message{
    List<Message> messages = [];

    messages.addAll(sentMessages.toList());
    messages.addAll(gotMessages.toList());
    return messages;
  }


  List<MessageSender> get sender{
    _messageSender.sort((a, b) => (b.gotMessage.length + b.sentMessage.length).compareTo(a.sentMessage.length + a.gotMessage.length));
    return _messageSender;
  }


  void add(MessageSender m){
    _messageSender.add(m);
  }

  Future<void> syncAllMessages()async{

    for(MessageSender ms in _messageSender){
     await  ms.syncMessages();
    }
    notifyListeners();

  }

  Future<void> syncMessageSender(String path)async{

    final dir = Directory("$path/your_instagram_activity/messages/inbox");
    final List<Directory> subDirs = [];

    await for (var entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is Directory) {
        subDirs.add(entity);
      }
    }

    for(Directory d in subDirs){
      String name = p.basename(d.path).split("_")[0];
      MessageSender ms = MessageSender(name: name, path: d.path);
     _messageSender.add(ms);
    }

    await syncAllMessages();

    _messageSender.sort((a, b) => (a.gotMessage.length + a.sentMessage.length).compareTo(b.sentMessage.length + b.gotMessage.length));


    notifyListeners();

  }

  List<FlSpot> getSentMessagesChartData(){
    List<FlSpot> dataPoints = [];
    List<Message> sentMessages = [];
    int firstTimestamp = 0;

    sentMessages = this.sentMessages;

    sentMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if(!sentMessages.isEmpty) firstTimestamp = sentMessages[0].timestamp;


    for(int i = 0; i < sentMessages.length; i += 1){
      dataPoints.add(FlSpot(sentMessages[i].timestamp.toDouble() - firstTimestamp, i.toDouble()));
    }


    return dataPoints;
  }

  List<FlSpot> getGotMessagesChartData(){
    List<FlSpot> dataPoints = [];
    List<Message> gotMessages = [];
    int firstTimestamp = 0;

    gotMessages = this.gotMessages;

    gotMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if(!gotMessages.isEmpty) firstTimestamp = gotMessages[0].timestamp;


    for(int i = 0; i < gotMessages.length; i += 1){
      dataPoints.add(FlSpot(gotMessages[i].timestamp.toDouble() - firstTimestamp, i.toDouble()));
    }


    return dataPoints;
  }

  List<List<FlSpot>> getMostActiveMessagesChartData(){
    List<List<FlSpot>> data = [];
    List<MessageSender> sender = [];
    sender = _messageSender;
    int lowestTimestamp = double.maxFinite.toInt();

    messageSender.sort((a, b) => (b.gotMessage.length + b.sentMessage.length).compareTo(a.sentMessage.length + a.gotMessage.length));


    if(sender.length <= 0) return data;

    for(int i = 0; i < 5; i++){
      List<Message> messages = [];
      messages = sender[i].messages;
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      if(messages.isNotEmpty && messages[0].timestamp < lowestTimestamp){
        lowestTimestamp = messages[0].timestamp;
      }

    }


    for(int i = 0; i < 5; i++){
      data.add(sender[i].getMessagesChartData(firstTimestamp: lowestTimestamp));
    }
    return data;

  }

  List<double> get getHeatMapData {
    List<double> data = List.filled(24, 0.0); // Stelle sicher, dass der Listentyp korrekt ist
    List<Message> messages = [];
    messages.addAll(sentMessages.toList());
    messages.addAll(gotMessages.toList());

    for (Message m in messages) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(m.timestamp * 1000);
      int hour = date.hour;
      data[hour]++;  // Erhöhe den Zähler für die entsprechende Stunde
    }

    double maxValue = data.reduce(max);

    for (int i = 0; i < data.length; i++) {
      if (maxValue > 0) {
        double ratio = data[i] / maxValue;
        data[i] = ratio * 100;
      }
    }


    return data;
  }

}