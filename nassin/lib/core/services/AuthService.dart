import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  final _googleAuth = GoogleSignIn();

  Future<FirebaseUser> get user async{
    return await _auth.currentUser();
  }

  Future<FirebaseUser> signInWithGoogle() async {
    FirebaseUser user;

    final GoogleSignInAccount googleUser = await _googleAuth.signIn();

    if(googleUser == null){
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
    );

    print("3" + credential.toString());


    user = (await _auth.signInWithCredential(credential)).user;

    print("4" + user.toString());

    return user;
  }

  Future<void> signOutGoogle() async {
    await _auth.signOut();
    return await _googleAuth.signOut();
  }

  signOut() {
    _auth.signOut();
  }
}
