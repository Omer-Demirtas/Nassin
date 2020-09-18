import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorService{
  final _key = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get key => _key;

  navigateAndReplace(Widget widget){
    _key.currentState.pushReplacement(MaterialPageRoute(
      builder: (context) => widget
    ));
  }


  navigateAndDelete(Widget widget){
    _key.currentState.pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => widget
    ),(Route<dynamic> route) {
      return false;
    }
    );

}

  navigateTo(Widget widget){
    _key.currentState.push(
        MaterialPageRoute(builder: (context) => widget,));
  }
}