import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nassin/Settings.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/model/Entry.dart';
import 'package:nassin/viewModules/StreamPageModel.dart';
import 'package:nassin/widgets/EntryWidget.dart';

class GenericStreamPage extends StatelessWidget {
  final StreamPageModel model = getIt<StreamPageModel>();
  final ScrollController _scrollController = ScrollController();
  double width;

  @override
  Widget build(BuildContext context) {
    MediaQuery
        .of(context)
        .size
        .width;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: model.getAllEntries(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                List<Entry> entries;
                if(snapshot.hasData){
                  entries = snapshot.data.documents.map((e) {
                    return Entry.fromMap(e.data);
                  }).toList();
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      Entry entry = entries[index];
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                            width: width,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${entry.senderName}",style: Settings.profileStyle,),
                                      Text(entry.sendTime.toDate().toString().substring(0,19)),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text( entry.content.length > 100 ?
                                    "${entry.content.substring(0,100)}..." :
                                    entry.content,
                                    ),
                                  ),
                                  Spacer(),
                                  Center(
                                    child: IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onPressed: () {  },
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      );
                    },
                  );
                }
                if(!snapshot.hasData){
                  return Center(
                    child: Text("Stream Not Found!!"),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      )
    );
  }
}
