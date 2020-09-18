import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/core/services/StorageService.dart';
import 'package:nassin/model/Message.dart';
import 'package:nassin/viewModules/BaseModel.dart';

class ConversationModel extends BaseModel{
  final _db = GetIt.instance<FireStoreDb>();
  final _storage = getIt<StorageService>();

  Stream<List<Message>> getMessages(String chatId,String userId){
    return _db.getMessage(chatId,userId);
  }

  Future<void> addMessage(Message msg, String userId, String chatId) async {
    if(msg.imagePath == null && msg.content == ""){
      return null;
    }
    return await _db.addMessage(msg, userId, chatId);
  }

  Future<String> uploadMedia(ImageSource source, String userId, String chatId) async {
    PickedFile file = await ImagePicker().getImage(source: source);

    if(file == null) return null;

    String url = await _storage.uploadMedia(File(file.path));

    notifyListeners();

    Message message = Message(
      sendTime: Timestamp.now(),
      imagePath: url,
      content: ""
    );

    await addMessage(message, userId, chatId);

    return url;
  }

}

