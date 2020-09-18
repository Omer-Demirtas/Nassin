import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/viewModules/SignInModel.dart';

import '../Settings.dart';

class ProfilePage extends StatelessWidget {
  final _db = getIt<FireStoreDb>();
  final Profile user;
  final model = getIt<SignInModel>();

  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: Column(children: [
          Padding(
            child: CircleAvatar(
                radius: 150, backgroundImage: NetworkImage(user.image)),
            padding: EdgeInsets.only(top: 16),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(),
                ),
                Text(
                  user.name,
                  style: Settings.profileStyle,
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: RaisedButton(
                color: Colors.red,
                child: Text("sing out"),
                onPressed: () async {
                  bool value = await model.showDialog(context, "Are you sure?", "Sign Out!");

                  if(value == null) return;

                  if(value == true) return await model.signOut();
                }
            ),
          )
        ]
        )
    );
  }
}

