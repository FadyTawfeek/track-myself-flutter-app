//import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/screens/play_game_screen.dart';
//import '../screens/addNormalMedication_screen.dart';
import '../screens/addSymptom_screen.dart';
import '../screens/user_survey_screen.dart';
import '../screens/more_screen.dart';
import '../widgets/app_drawer.dart';
import 'addNormalMedicationGroup_screen.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as statusCodes;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
//import 'package:intl/intl.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//import 'package:location/location.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyHomePage extends StatefulWidget {
  static const routeName = '/';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterLocalNotificationsPlugin fltrNotification;

  @override
  void initState() {
    tz.initializeTimeZones();

    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    showDailyAtTime();
    //print("1");
    // Future<Null>.delayed(Duration.zero, () {
    //   scaffoldKey.currentState.showSnackBar(
    //     SnackBar(content: Text("Symptom was added.")),
    //   );
    // });
    //_asyncStuff();
    //print("2");
    // fltrNotification2 = new FlutterLocalNotificationsPlugin();
    // fltrNotification2.initialize(initilizationsSettings,
    //     onSelectNotification: notificationSelected2);
    // showDailyAtDefaultMedicationGroupsTimes();
    super.initState();
  }

  // Future<void> _asyncStuff() async {
  //   print("object");
  //   scaffoldKey.currentState
  //       .showSnackBar(SnackBar(content: Text("Symptom was added")));
  //   print("object2");
  // }

  Future notificationSelected(String payload) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification : $payload"),
    //   ),
    // );
    Navigator.of(context).pushNamed(
      AddSymptomScreen.routeName,
    );
  }

  // Future notificationSelected2(String payload) async {
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (context) => AlertDialog(
  //   //     content: Text("Notification : $payload"),
  //   //   ),
  //   // );
  //   Navigator.of(context).pushReplacementNamed(
  //     AddNormalMedicationGroupScreen.routeName,
  //   );
  // }

  // Future _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails("id", "a", "b",
  //       importance: Importance.max);
  //   var iSODetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //       new NotificationDetails(android: androidDetails, iOS: iSODetails);

  //   await fltrNotification.show(0, "Daily survey",
  //       "Remember to fill your daily survey", generalNotificationDetails,
  //       payload: "Task");
  // }

  Future<void> showDailyAtTime() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //var time = Time(02, 45, 00);

    var androidDetails = new AndroidNotificationDetails(
        "id", "Daily symptoms survey", "b",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await fltrNotification.zonedSchedule(
        0,
        "Reminder",
        "Remember to report today's symptoms survey",
        tz.TZDateTime.local(2050, 01, 01, 20, 00),
        generalNotificationDetails,
        uiLocalNotificationDateInterpretation: null,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.time);
    //print("started daily reminders");
    //DateTimeComponents.matchTime

    // await fltrNotification.showDailyAtTime(0, "Daily survey",
    //     "Remember to fill your daily survey", time, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Track Myself'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: HomePageBottomBar(height, width),
      appBar: appBar,
      //drawer: AppDrawer(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              //FittedBox(
              //fit: BoxFit.fitWidth,
              // child: FittedBox(
              //   fit: BoxFit.cover,
              //child:
              Text(
                "Welcome to Track Myself!\n\n= To play the game, press the 'Play now' button.\n\n= To add a medication group intake, press the 'Medication' button, if you want to add only a booster medication, press the 'Add booster instead' button you find there.\n\n= To add the daily symptom survey, press the 'Daily Survey' button, or press on the 8 PM reminder you will receive.\n\n= To change game settings, check your previous records, and see your dashboard, press the 'More' button.\n\nNote that you need internet access on your phone while using the app.\n\n",
                style: TextStyle(
                  color: Colors.lightBlue[900],
                  //fontSize: 14,
                  //width * 0.04,
                  fontWeight: FontWeight.bold,
                  //fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              //),
              Center(
                child: Container(
                  height: height * 0.1,
                  width: width * 0.5,
                  child: RaisedButton(
                    elevation: 15,
                    color: Colors.lightBlue[900],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pushNamed(PlayGameScreen.routeName);
                    },
                    child: Text(
                      "Play now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePageBottomBar extends StatelessWidget {
  final height;
  final width;
  HomePageBottomBar(this.height, this.width);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: height / 5,
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
                      //disabledColor: Colors.blue,
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.gamepad,
                            color: Colors.amber[900],
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                              color: Colors.amber[900],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
                      //disabledColor: Colors.blue,
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AddNormalMedicationGroupScreen.routeName,
                        );
                      },

                      //////////////////////
                      /////////////////////
                      ////////////////////
                      ///////////////////
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.assignment_return,
                            color: Colors.white,
                          ),
                          Text(
                            "Medication",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
                      //disabledColor: Colors.blue,
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          AddSymptomScreen.routeName,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.accessibility_new,
                            color: Colors.white,
                          ),
                          Text(
                            "Daily Survey",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //  IconButton(
                  //   //iconSize: 30.0,
                  //   //padding: EdgeInsets.all(10),
                  //   //only(left: 28.0),
                  //   icon: Icon(Icons.gamepad),
                  //   onPressed: () {},
                  // ),
                ),
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
                      //disabledColor: Colors.blue,
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          MoreScreen.routeName,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.more,
                            color: Colors.white,
                          ),
                          Text(
                            "More",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
