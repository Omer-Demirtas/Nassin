import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:nassin/model/Conversation.dart';
import 'package:nassin/model/Message.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/viewModules/ConversationModel.dart';
import 'package:nassin/widgets/MessageWidget.dart';
import '../Settings.dart';

class ConversationPage extends StatefulWidget {
  final String userId;
  final Conversation chat;
  final Profile receiver;

  ConversationPage({Key key, this.userId, this.chat, this.receiver}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _ConversationPage(
      chat: chat,
      userId: userId,
      receiver: receiver
    );
  }
}


class _ConversationPage extends State<ConversationPage> {
  final String userId;
  final Conversation chat;
  final Profile receiver;

  final TextEditingController _controller =  TextEditingController();
  FocusNode _focusNode;
  ScrollController _scrollController;

  bool _visibleDownButton = false;

  _ConversationPage({this.userId, this.chat, this.receiver});

  @override
  void initState() {
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    super.initState();
    //_scrollController.addListener(_scrollListener);
  }

  void slideEnd(){
      if(_scrollController.position.maxScrollExtent != 0){
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(microseconds: 200),
            curve: Curves.easeIn);
      }
  }

  void _scrollListener(){
    if(_scrollController.position.maxScrollExtent != 0 ){
      _visibleDownButton = true;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConversationModel model = GetIt.instance<ConversationModel>();
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(receiver.image),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(receiver.name,style: Settings.textStyle,),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: Colors.grey.withOpacity(0.7),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _focusNode.unfocus();
                        },
                        child: StreamBuilder(
                            stream: model.getMessages(chat.id,userId),
                            builder: (context,AsyncSnapshot<List<Message>> snapshot) {
                              if(snapshot.hasData){
                                return ListView(
                                  controller: _scrollController,
                                  children: snapshot.data.
                                  map((e) {
                                    return MessageWidget(message: e);
                                  }).toList(),
                                );
                              }
                              if(!snapshot.hasData){
                                return Center(
                                  child: Text("You haven't any message yet!!"),
                                );
                              }
                              else{
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(40),
                          right: Radius.circular(40),
                        ),
                        border: Border.all(
                          color: Colors.black,
                          width: 4,
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(40),
                                    right: Radius.circular(40),
                                  )

                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: TextField(
                                          focusNode: _focusNode,
                                          controller: _controller,
                                        ),
                                      )
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.attach_file),
                                    onPressed: () async{
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Container(
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Camera" , style: Settings.textStyle,),
                                                onTap: () async{
                                                  saveImage(ImageSource.camera, model);
                                                },
                                              ),
                                              ListTile(
                                                  leading: Icon(Icons.insert_drive_file),
                                                  title: Text("Gallery",style: Settings.textStyle,),
                                                  onTap: () async{
                                                    saveImage(ImageSource.gallery, model);                                            }
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: () async {
                                      String text = _controller.text;
                                      _controller.text = "";

                                      Message msg = Message(
                                        sendTime: Timestamp.now(),
                                        content: text,
                                      );

                                      await model.addMessage(msg, userId, chat.id);

                                      _scrollController.animateTo(
                                          _scrollController.position.maxScrollExtent,
                                          duration: Duration(microseconds: 200),
                                          curve: Curves.easeIn);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ),
        )
        )
    );
  }

  saveImage(ImageSource source, ConversationModel model) async{
    String url = await model.uploadMedia(source,userId,chat.id);
  }
}
