import 'package:flutter/material.dart';
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

    void _myFunction() {
      setState(() {
        flag = true;
      });

      print("the flag is $flag");
      gyroscopeEvents.listen((GyroscopeEvent event) {
        if (flag == true) {
          setState(() {
            value = event;
          });
          print(value);
        }
      });
    }

    void _flip() {
      flag = false;
      print(flag);
    }

    return Scaffold(
      appBar: appBar,
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
          ),
          onPressed: () {
            setState(() {
              flag = false;
            });
          },
        ));
  }
}
