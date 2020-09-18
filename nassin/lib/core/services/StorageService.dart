

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService{

  final _storage = FirebaseStorage.instance;


  Future<String> uploadMedia(File file) async{

    var media = _storage.ref().child("${DateTime.now().
    millisecondsSinceEpoch}.${file.path.split('.').last}").
    putFile(file);

    media.events.listen((event)  async{});

    var result = await media.onComplete;
    return await result.ref.getDownloadURL();

  }


}