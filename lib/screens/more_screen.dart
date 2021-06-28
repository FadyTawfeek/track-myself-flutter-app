import 'package:flutter/material.dart';
import 'package:stop1/screens/dashboard_screen.dart';
import 'package:stop1/screens/symptoms_screen.dart';
import 'addNormalMedicationGroup_screen.dart';
import 'addSymptom_screen.dart';
import 'default_medications_groups_screen.dart';
import 'games_screen.dart';
import 'settings_screen.dart';
import 'default_medications_screen.dart';
import 'normalMedicationsGroups_screen.dart';
import 'normalMedications_screen.dart';

class MoreScreen extends StatelessWidget {
  static const routeName = '/more';
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('More'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    return Scaffold(
      bottomNavigationBar: MoreScreenBottomBar(height, width),
      appBar: appBar,
      body: SafeArea(
        child: Container(
          height: height * 0.8,
          child: ListView(
            children: <Widget>[
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                  child: Text("Settings"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context)
                        .pushNamed(DefaultMedicationsScreen.routeName);
                  },
                  child: Text("Doctor Medications (for doctors)"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context)
                        .pushNamed(DefaultMedicationsGroupsScreen.routeName);
                  },
                  child: Text("Doctor Medication groups (for doctors)"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context)
                        .pushNamed(NormalMedicationsGroupsScreen.routeName);
                  },
                  child: Text("My Medication groups"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context)
                        .pushNamed(NormalMedicationsScreen.routeName);
                  },
                  child: Text("My Booster Medications"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context).pushNamed(GamesScreen.routeName);
                  },
                  child: Text("My Games Scores"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context).pushNamed(SymptomsScreen.routeName);
                  },
                  child: Text("My Daily Symptoms Surveys"),
                ),
              ),
              Container(
                height: height * 0.8 / 8,
                padding: EdgeInsets.fromLTRB(
                    width * 0.03, height * 0.01, width * 0.03, height * 0.01),
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
                    Navigator.of(context).pushNamed(DashboardScreen.routeName);
                  },
                  child: Text("Dashboard"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoreScreenBottomBar extends StatelessWidget {
  final height;
  final width;
  MoreScreenBottomBar(this.height, this.width);
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
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/'));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.gamepad,
                            color: Colors.white,
                          ),
                          Text(
                            "Home",
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
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AddNormalMedicationGroupScreen.routeName,
                        );
                      },
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
                      color: Colors.lightBlue[900],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.black,
                            width: 2,
                            style: BorderStyle.solid),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
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
                ),
                Expanded(
                  child: SizedBox(
                    height: height / 10,
                    width: width / 2,
                    child: FlatButton(
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
                            Icons.more,
                            color: Colors.amber[900],
                          ),
                          Text(
                            "More",
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
