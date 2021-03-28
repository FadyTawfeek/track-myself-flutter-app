//import 'dart:html';

import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:sensors/sensors.dart';

class UserSurveyScreen extends StatefulWidget {
  static const routeName = '/user-survey';

  @override
  _UserSurveyScreenState createState() => _UserSurveyScreenState();
}

class _UserSurveyScreenState extends State<UserSurveyScreen> {
  bool flag = true;
  GyroscopeEvent value;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      backgroundColor: Colors.lightBlue[900],
      title: Text('STOP-user survey'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    //bool flag = false;
    void _myFunction() {
      setState(() {
        flag = true;
      });
      //GyroscopeEvent value;
      print("the flag is $flag");
      gyroscopeEvents.listen((GyroscopeEvent event) {
        //print(event);
        //value = event;
        //print(value);

        if (flag == true) {
          setState(() {
            value = event;
          });
          print(value);
        }

        //print(value);
      });
      // if (flag == true) {
      //   print(value);
      // }
      //return value;
    }

    void _flip() {
      flag = false;
      print(flag);
    }

    return Scaffold(
      appBar: appBar,
      //drawer: AppDrawer(),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                onPressed: _myFunction,
                child: Text(
                  "Start",
                ),
              ),
              Text(
                "this is my output: ${value.toString()}",
              ),
              thisScreenNeeds(),

              // FlatButton(
              //   onPressed: _flip,
              //   child: Text(
              //     "Stop",
              //   ),
              // ),

              // Text(
              //   "this is my output: ${_myFunction()}",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget thisScreenNeeds() {
    return Container(
        margin: EdgeInsets.only(top: 100, left: 50),
        child: FlatButton(
          child: Text(
            "stop",
            textAlign: TextAlign.center,
            // style: (TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 60,
            //     color: Colors.green)
            //     ),
          ),
          onPressed: () {
            setState(() {
              flag = false;
            });
          },
        ));
  }
}
