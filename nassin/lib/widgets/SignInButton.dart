import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/ui/HomePage.dart';
import 'package:nassin/viewModules/SignInModel.dart';

class SignInButton extends StatelessWidget  {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    var model = getIt<SignInModel>();

    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async{
        user = await model.signInWithGoogle();
        model.navigatorService.navigateAndDelete(HomePage(user: user,));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}