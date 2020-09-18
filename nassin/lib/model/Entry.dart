import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/framework.dart';

class Entry {
  String id;
  String title;
  String content;
  String senderId;
  String senderName;
  Timestamp sendTime;

  Entry(
      {this.id,
      this.title,
      this.content,
      this.senderId,
      this.senderName,
      this.sendTime});

  static Entry fromSnapshot(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Entry(
        //title: snapshot.data.documents.
        );
  }

  static Entry fromMap(Map<String, dynamic> data) {
    return Entry(
        title: data["title"],
        sendTime: data["sendTime"],
        content: data["content"],
        senderName: data["senderName"],
        id: data["id"]);
  }
}
