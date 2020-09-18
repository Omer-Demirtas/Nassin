import 'package:flutter/material.dart';
import 'package:nassin/core/services/AuthService.dart';
import 'package:nassin/model/Message.dart';

import '../Settings.dart';
import 'ImageView.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Alignment side = message.sender ?
    Alignment.centerRight:
    Alignment.centerLeft;

    return ListTile(
      title: Align(
        alignment: side,
        child: message.imagePath != null ? ImageView(url: message.imagePath,) :
            null
      ),
      subtitle: message.content != "" ?
      Align(
        alignment: side,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: side == Alignment.centerRight ?
            Colors.green:
            Colors.black,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10),
              right: Radius.circular(10),
            ),
          ),
          child: Text(message.content, style: Settings.messageStyle,)
        ),
      )
          :
          null,
    );
  }
}
