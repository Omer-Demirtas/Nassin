import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/PushNotificationService.dart';
import 'package:nassin/ui/ContactPage.dart';
import 'BaseModel.dart';

class MainModel extends BaseModel {
  final PushNotificationService _pns = getIt<PushNotificationService>();
  final FirebaseMessaging _fm = getIt<PushNotificationService>().fm;

  Future<void> navigateToContact(FirebaseUser user) {
    return navigatorService.navigateTo(ContactPage(
      fUser: user,
    ));
  }

  initialise(GlobalKey<ScaffoldState> key){
    if(Platform.isIOS){
      _fm.requestNotificationPermissions(IosNotificationSettings());
    }


    _fm.configure(
      onMessage: (Map<String, dynamic> message) => _onMessage(message, key),
      onLaunch: (Map<String, dynamic> message) => _onLunch(message),
      onResume: (Map<String, dynamic> message) => _onResume(message),
    );
  }
  //called when the app is in foreground
  _onMessage(Map<String, dynamic> message,GlobalKey<ScaffoldState> key) async{
      Scaffold.of(key.currentContext).showSnackBar(SnackBar(content: Text("sa"),));
    }
  //opened with push notification directly
  _onLunch(Map<String, dynamic> message) async{
  }
  //called when the app is in background
  _onResume(Map<String, dynamic> message) async{
  }

  Future<void> init(GlobalKey<ScaffoldState> key) async{
    initialise(key);
    String token = await _pns.getUserToken();
  }
}