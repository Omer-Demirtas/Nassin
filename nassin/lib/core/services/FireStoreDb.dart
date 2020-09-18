import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:nassin/model/Conversation.dart';
import 'package:nassin/model/Entry.dart';
import 'package:nassin/model/Message.dart';
import 'package:nassin/model/Profile.dart';

class FireStoreDb{
  final String _tableCon = "conversation";
  final String _tableEntry = "entries" ;
  final Firestore _fireStore = Firestore.instance;

  getGoogleConversation(String userId){

  }

  getConversation(String userId) {
    var conversationStream = _fireStore.collection("$_tableCon").
    where("members",arrayContains: userId).snapshots();

    Stream<List<Profile>> contactStream = getContact();

    return Rx.combineLatest2(conversationStream, contactStream,
            (QuerySnapshot conversations,
            List<Profile> profiles
            ) {
          return conversations.documents.map((e) {
            List users = e.data["members"];
            users.remove(userId);
            return Conversation.fromSnapshot(
                e,
                profiles.firstWhere((prof) => prof.id == users.first)
            );
          }).toList();
        });
  }

  Stream<List<Message>> getMessage(String conversationId ,String userId){
    var ref = _fireStore.collection("$_tableCon/$conversationId/messages").
    orderBy("sendTime");
    Stream<List<Message>> val =  ref.snapshots().map((event) =>
        event.documents.map((e) =>
          Message.fromSnapshot(e,userId)
        ).toList());

    return val;
  }

  getContacts(String userId){
    return _fireStore.collection("$_tableCon").
    where("members",
    arrayContains: userId).getDocuments().then((value) => value.documents.map((e) {
      return e.data;
    }).toList());
  }

  Stream<List<Profile>> getContact(){
    var ref = _fireStore.collection("profile").orderBy("userName");

    return ref.snapshots().map((event) => event.documents.
    map((e) => Profile(
      image: e.data["image"],
      id: e.data["id"],
      name: e.data['userName'],
    )).toList());
  }

  Future<Profile> getProfileByConversationId(String conversationId, String userId) async{
    List profiles = await _fireStore.collection("$_tableCon").document("$conversationId").get().then((value) => value.data["members"]);

    String profileId = profiles.where((element) => element != userId).toString();

    Profile profile = await getUserById(profileId.substring(1,profileId.length -1));

    return profile;
  }

  Future<void> addMessage(Message message,String userId, chatId) async {
    var data = {
      "message":message.content,
      "sender":userId,
      "sendTime":message.sendTime
    };

    message.imagePath != null ?
        data["imagePath"] = message.imagePath: null;

    await _fireStore.collection("message").add(data);

    return await _fireStore.collection("$_tableCon/$chatId/messages").add(data);

  }

  Future<String> checkConversations(String userId, String receiveId) async{
    List<DocumentSnapshot> q1 = await _fireStore.collection("$_tableCon").where(
      "members",
      arrayContains: userId
    ).
    getDocuments().then((value) {
      return value.documents;
    });
    for(var e in q1) {
      List a = e.data["members"];

      a.removeWhere((element) => element == userId);
      if (a.length > 1) {
        continue;
      }
      if (a.first == receiveId) {
        return e.documentID;
      }
    }
    return "0";
  }

  Future<Conversation> startConversation(String userId, Profile receiver) async{
    var document = await _fireStore.collection("$_tableCon").add(
      {
        "members":[receiver.id, userId],
      }
    );

    return Conversation(
      id: document.documentID,
      profile: receiver
    );
  }

  Future<Profile> getUserById(String userId) async {

    var value = _fireStore.collection("profile").where("id",isEqualTo: userId);

    Profile user = await value.getDocuments().then((value) => Profile.fromJson(value.documents.first.data));

    return user;
  }

  Stream<QuerySnapshot> getAllEntries() {
    return _fireStore.collection(_tableEntry).orderBy("sendTime", descending: true).snapshots();
}

  Future<void> saveEntry(Entry entry) async {
    var data = {
      "senderName": entry.senderName,
      "content": entry.content,
      "title": entry.title,
      "sendTime": entry.sendTime,

    };
    return await _fireStore.collection(_tableEntry).add(data);
  }


  userIsExists(FirebaseUser user) async {
    await _fireStore.document("/profile/${user.uid}").get().
    then((value) {
      if(!value.exists){
        return false;
      }
      else{
        return true;
      }
    });
  }

  updateAndCreateUser(Map<String, dynamic> userData) async{
    await _fireStore.collection("/profile").document("${userData["id"]}").
    setData(userData);
  }

}


