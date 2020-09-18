

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/model/Entry.dart';
import 'package:nassin/viewModules/BaseModel.dart';

class StreamPageModel extends BaseModel{
  final FireStoreDb _db =  getIt<FireStoreDb>();

  Stream<QuerySnapshot> getAllEntries(){
    return _db.getAllEntries();
  }

  saveEntry(Entry entry) async {
    await _db.saveEntry(entry);
  }

}