


import 'package:cloud_firestore/cloud_firestore.dart';

import 'Profile.dart';

class Conversation{
  String id;
  Profile profile;

  Conversation({this.id, this.profile});

  factory Conversation.fromSnapshot(DocumentSnapshot snapshot, Profile profile) {
    return Conversation(
        id: snapshot.documentID,
        profile: profile
    );
  }



}