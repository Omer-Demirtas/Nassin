

import 'dart:io';

import 'package:flutter/material.dart';

class ImageView extends StatelessWidget{
  final String url;

  const ImageView({Key key, this.url}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: SizedBox(
        child: Image.network(url),
        width: 250,
      )
    );
  }
}