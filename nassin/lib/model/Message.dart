

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  bool sender;
  Timestamp  sendTime;
  String content;
  String imagePath;

  Message({this.content,  this.sender, this.sendTime, this.imagePath});

  factory Message.fromSnapshot(DocumentSnapshot snapshot, userId){
    return Message(
      content: snapshot.data['message'],
      sender: snapshot.data['sender'] == userId ? true : false,
      sendTime: snapshot.data['sendTime'],
      imagePath: snapshot.data['imagePath']
    );
  }

}