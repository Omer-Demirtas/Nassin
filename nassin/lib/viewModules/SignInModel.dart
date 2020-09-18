import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/AuthService.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/core/services/PushNotificationService.dart';
import 'package:nassin/ui/GoogleSignIn.dart';
import 'package:nassin/ui/HomePage.dart';
import 'BaseModel.dart';

class SignInModel extends BaseModel {
  final AuthService _authService = getIt<AuthService>();
  final PushNotificationService _notificationService =
      getIt<PushNotificationService>();

  Future<FirebaseUser> get user async {
    FirebaseUser u = await _authService.user;

    u != null
        ? print("[info] user sign in with ${u.uid}")
        : print("[info] user sign in with $u");

    return u;
  }

  signOut() async {
    await _authService.signOutGoogle();

    if (await user == null) {
    }

    await navigatorService.navigateAndDelete(GoogleSignInPage());
  }

  Future<FirebaseUser> signInWithGoogle() async {
    busy = true;

    FirebaseUser user = await _authService.signInWithGoogle();

    String token = await _notificationService.getUserToken();

    Map<String, dynamic> userData = {
      'userName': user.displayName,
      'email': user.email,
      'image': user.photoUrl != null ? user.photoUrl : null,
      'id': user.uid,
      'token':token
    };

    db.updateAndCreateUser(userData);

    busy = false;

    return user;
  }
}
