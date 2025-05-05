
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramanalyzer/Apps/Instagram/Messages/message.dart';
import 'package:instagramanalyzer/Apps/Instagram/Messages/message_list.dart';
import 'package:provider/provider.dart';

import '../../../json_converter.dart';

class MessageSender{
  final String name;
  final String path;

  MessageSender({required this.name, required this.path});

  List<Message> _SentMessages = [];
  List<Message> _GotMessages = [];

  List<Message> get sentMessage{
    return _SentMessages;
  }
  
  List<Message> get gotMessage{
    return _GotMessages;
  }

  List<Message> get messages{

    List<Message> messages = [];
    messages = _SentMessages.toList();
    messages.addAll(_GotMessages);
    return messages;
  }



  void addSentMessage(Message m){
    _SentMessages.add(m);
  }
  
  void addGotMessage(Message m){
    _GotMessages.add(m);
  }

  Future<void> syncMessages() async {
    List<Map<String, dynamic>> participants = await JsonConverter.convertJsonFromFile(path: "$path/message_1.json", key: "participants");
    List<Map<String, dynamic>> messages = await JsonConverter.convertJsonFromFile(path: "$path/message_1.json", key: "messages");

    String myName = participants[1]["name"];
    String otherName = participants[0]["name"];
    _GotMessages.clear();
    _SentMessages.clear();


    for(Map<String, dynamic> m in messages){
        if(m["sender_name"] == myName){
          Message message = Message(text: m["content"] ?? "", timestamp: m["timestamp_ms"]);
          addSentMessage(message);
        }else{
          Message message = Message(text: m["content"] ?? "", timestamp: m["timestamp_ms"]);
          addGotMessage(message);
        }

    }
    

  }

  List<FlSpot> getMessagesChartData({int? firstTimestamp}) {
    List<FlSpot> dataPoints = [];
    List<Message> messages = _SentMessages.toList()..addAll(_GotMessages);

    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    int baseTimestamp = firstTimestamp ?? (messages.isNotEmpty ? messages.first.timestamp : 0);

    for (int i = 0; i < messages.length; i++) {
      dataPoints.add(FlSpot(
        messages[i].timestamp.toDouble() - baseTimestamp.toDouble(),
        i.toDouble(),
      ));
    }

   // if (dataPoints.length > 3) dataPoints.removeRange(0, 2);

    return dataPoints;
  }




}