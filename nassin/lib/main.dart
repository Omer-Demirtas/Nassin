import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nassin/ui/GoogleSignIn.dart';
import 'package:nassin/ui/HomePage.dart';
import 'package:nassin/viewModules/SignInModel.dart';

import 'core/locator.dart';
import 'core/services/NavigatorService.dart';

void main() {
  setupLocator();

  runApp(
    FutureProvider(
        create: (context) => getIt<SignInModel>().user,
        child: MaterialApp(
          navigatorKey: getIt<NavigatorService>().key,
          theme: ThemeData(primarySwatch: Colors.green),
          home: Consumer<FirebaseUser>(
            builder: (context,FirebaseUser user, child)
            => user == null ? GoogleSignInPage() : HomePage(user: user,),
          ),
        )),
  );
}

