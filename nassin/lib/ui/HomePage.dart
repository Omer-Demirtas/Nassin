import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/PushNotificationService.dart';
import 'package:nassin/model/Entry.dart';
import 'package:nassin/model/Profile.dart';
import 'package:nassin/ui/GenericStreamPage.dart';
import 'package:nassin/ui/SettingsPage.dart';
import 'package:nassin/viewModules/MainModel.dart';
import 'package:nassin/viewModules/StreamPageModel.dart';
import 'ChatPage.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }


}

enum Selection { profile, settings }

class _HomePage extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final model = getIt<MainModel>();
  final entryTextController = TextEditingController();
  final entryModel = getIt<StreamPageModel>();
  final notifyModel = getIt<PushNotificationService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _showMessage = true;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      _showMessage = _tabController.index == 0;
      setState(() {});
    });
    _tabController.index = 0;
    model.init(_scaffoldKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomSheet: !_showMessage
            ? BottomSheet(
                builder: (context) => Container(
                  padding: EdgeInsets.only(bottom: 4, left: 4, right: 4),
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              controller: entryTextController,
                              minLines: 1,
                              maxLines: 10,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file),
                        ),
                        IconButton(
                          onPressed: () async {
                            String msg = entryTextController.text;
                            if(msg.length == 0) return;

                            Entry entry = Entry(
                              senderName: widget.user.displayName,
                              content: msg,
                              sendTime: Timestamp.now(),
                              title: "title",
                              senderId: widget.user.uid
                            );

                            await entryModel.saveEntry(entry);

                            entryTextController.text = "";
                          },
                          icon: Icon(Icons.send),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                  ),
                ),
                onClosing: () {},
              )
            : null,
        floatingActionButton: _showMessage
            ? FloatingActionButton(
                onPressed: () async {
                  model.navigateToContact(widget.user);
                },
                child: Icon(Icons.message),
              )
            : null,
        body: Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      floating: true,
                      title: Text("Messaging"),
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                          },
                        ),
                        PopupMenuButton<Selection>(
                          itemBuilder: (context) {
                            return Selection.values.map((e) {
                              return PopupMenuItem<Selection>(
                                child: Text("${e.toString().split(".").last}"),
                                value: e,
                              );
                            }).toList();
                          },
                          icon: Icon(Icons.more_vert),
                          onSelected: (value) async {
                            switch (value) {
                              case Selection.profile:
                                Profile profile =
                                    await model.db.getUserById(widget.user.uid);
                                return model.navigatorService
                                    .navigateTo(ProfilePage(user: profile));
                              case Selection.settings:
                                return model.navigatorService.navigateTo(SettingsPage());
                            }
                          },
                        )
                      ],
                    )
                  ];
                },
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).primaryColor,
                        child: TabBar(
                          controller: _tabController,
                          tabs: <Widget>[
                            Tab(
                              child: Text("chat"),
                            ),
                            Tab(
                              child: Text("Generic Stream"),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ChatPage(
                              user: widget.user,
                            ),
                            GenericStreamPage(),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }

}

/*


*/
