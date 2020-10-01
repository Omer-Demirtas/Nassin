import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nassin/core/locator.dart';
import 'package:provider/provider.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/model/Conversation.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/viewModules/ChatModel.dart';

import 'ConversationPage.dart';

class ChatPage extends StatelessWidget{
  final FirebaseUser user;

  ChatPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var model = GetIt.instance<ChatModel>();
    var mainModel = getIt<FireStoreDb>();

    return ChangeNotifierProvider(
      create: (context) => model,
      child: StreamBuilder(
        stream: model.conversations(user.uid),
        builder: (context, AsyncSnapshot<List<Conversation>> snapshot) {
          if(snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((e) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      onTap:  () async{
                        Profile profile = await mainModel.getProfileByConversationId(e.id, user.uid);
                        return Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ConversationPage(
                            chat: e,
                            userId: user.uid,
                            receiver: profile
                          ),
                        ));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(e.profile.image),
                      ),
                      title: Text(e.profile.name),
                    ),
                    Divider(),
                  ],
                );
              }).toList());
          }
          if(!snapshot.hasData){
            return Container(
              color: Colors.grey,
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text(
              """
              Bie hata oluştu!
              ${snapshot.error}
              """
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}