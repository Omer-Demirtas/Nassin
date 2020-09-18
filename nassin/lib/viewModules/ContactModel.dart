import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/model/Conversation.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/ui/ConversationPage.dart';

import 'BaseModel.dart';

class ContactModel extends BaseModel {
  final _db = getIt<FireStoreDb>();

  Stream<List<Profile>> getContact() {
    return _db.getContact();
  }

  Future<List<Profile>> getGoogleContact(){


    return null;
  }

  Future<void> startConversation(String userId, Profile profile) async {
    String chatId =
    await _db.checkConversations(userId, profile.id);
    Conversation conversation;

    if(userId == profile.id){
      return false;
    }
    if(chatId == "0"){
      conversation = await _db.startConversation(userId, profile);
      return await navigatorService.
      navigateTo(ConversationPage(
        chat: conversation,
        userId: userId,
        receiver: profile,
      ));
    }
    else{
      return await navigatorService.
      navigateTo(ConversationPage(
        chat: Conversation(
          id: chatId,
          profile: profile,
        ),
        userId: userId,
        receiver: profile,
      ));
    }
  }
}
