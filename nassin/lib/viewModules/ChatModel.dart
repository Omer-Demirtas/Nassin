import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/model/Conversation.dart';

//datalarda herhangi bir değişiklik olduğunda ui'ı rebuild etmek şçin

class ChatModel with ChangeNotifier{

  final _db =  GetIt.instance<FireStoreDb>();
  
  Stream<List<Conversation>> conversations (String userId)  {
    return  _db.getConversation(userId);
  }
}