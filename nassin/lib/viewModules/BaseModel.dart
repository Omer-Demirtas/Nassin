import 'package:flutter/material.dart';
import 'package:nassin/core/locator.dart';
import 'package:nassin/core/services/FireStoreDb.dart';
import 'package:nassin/core/services/NavigatorService.dart';

import '../Settings.dart';

class BaseModel extends ChangeNotifier {
  var navigatorService = getIt<NavigatorService>();
  var db = getIt<FireStoreDb>();

  bool _busy = false;

  bool get busy => _busy;

  set busy(bool val){
    _busy = val;
    notifyListeners();
  }

  Future<bool> showDialog(BuildContext context,
      String content,
      String title) async {

    int lines = content.split("\n").length;
    double height = lines == 1 ? ((lines * 100) + 100).toDouble() :
    (lines * 100).toDouble();

    return await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                      child: Column(
                        children: [
                          Text(title,style: Settings.profileStyle,),
                          Padding(
                            padding: EdgeInsets.only(top: 24,),
                            child: Text(content
                              ,style: Settings.profileStyle,),
                          )
                        ],
                      )
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context,true);
                          },
                          child: Text(
                            "OK",
                            style: Settings.profileStyle,
                          ),
                        ),
                        RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context,false );
                          },
                          child: Text(
                            "CANCEL",
                            style: Settings.profileStyle,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            margin: EdgeInsets.only(bottom: 10, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }


}