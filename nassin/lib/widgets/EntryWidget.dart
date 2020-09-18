import 'package:flutter/material.dart';
import 'package:nassin/model/Entry.dart';

class EntryWidget extends StatelessWidget {
  final Entry entry;
  final double width;

  const EntryWidget({Key key, this.width, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          width: width,
          height: 155,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(entry.senderName),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      height: 90,
                      width: 400,
                      color: Colors.white,
                      child: Text(entry.content),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(Icons.keyboard_arrow_down),
                  )
                ],
              ),
            )
          ),
        ));
  }
}
