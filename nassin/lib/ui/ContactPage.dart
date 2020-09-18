import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/viewModules/ContactModel.dart';

import 'ConversationPage.dart';

class ContactPage extends StatelessWidget{
  final FirebaseUser fUser;

  const ContactPage({Key key, this.fUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = getIt<ContactModel>();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.group),
            ),
            title: Text("add a new group"),
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person_add),
            ),
            title: Text("add a new group"),
          ),
          Divider(),
          Expanded(
            child: StreamBuilder(
              stream: model.getContact(),
              builder: (context,AsyncSnapshot<List<Profile>> snapshot) {
                List<Profile> profiles = snapshot.data;
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      Profile user = profiles[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(user.name),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              backgroundImage: NetworkImage(user.image),
                            ),
                            onTap: ()async{
                              await model.startConversation(fUser.uid, user);
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                }
                else{
                  return Container();
                }
              },
            ),
          ),


        ],
      ),
    );
  }
}