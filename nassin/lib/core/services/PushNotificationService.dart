import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  final FirebaseMessaging fm = FirebaseMessaging();
  final String serverToken = '<AAAA3CrLFiA:APA91bFqY_pnsHuxq-n6HDHG_eh7p9dFw2ZpgiGrUouVT6EZeqayHmx6VmgiVD-0243iv4Qmgyxvkd2spvv1R3thZiMd1PGOT8XsBtrTR-iyZXHP7yw7Qw9WP9_2OYgrRfCDrV55VktT>';

  // Replace with server token from firebase console settings.
  //final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  PushNotificationService(){
    //controlUserToken();
  }

  Future<void> controlUserToken() async {
    String userToken = await getUserToken();
    return null;
  }

  Future<String> getUserToken() async {
    return await fm.getToken();
  }


}