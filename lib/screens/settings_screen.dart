import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String chosenDifficulty;
  int chosenIndex;

  List<bool> chosenButtonCheck = [
    false,
    false,
    false,
  ];
  List<String> chosenButtonDifficulties = [
    "Easy (0.5 seconds)",
    "Medium (1.5 seconds)",
    "Hard (3 seconds)",
  ];

  void updateDifficulty(String newName) {
    setState(() {
      chosenDifficulty = newName;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  _saveDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();

    final key = 'my_diff_key';

    difficultyPreference.setString(key, chosenDifficulty);
  }

  Future<void> _readDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();

    final key = 'my_diff_key';
    final value = difficultyPreference.getString(key) ?? "Easy (0.5 seconds)";

    setState(() {
      chosenDifficulty = value;
    });
  }

  _saveDifficultyIndex() async {
    final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_index_key';

    difficultyPreferenceIndex.setInt(key, chosenIndex);
  }

  Future<void> _readDifficultyIndex() async {
    final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_index_key';
    final value = difficultyPreferenceIndex.getInt(key) ?? 0;

    setState(() {
      chosenIndex = value;
      chosenButtonCheck[chosenIndex] = true;
    });
  }

  @override
  void initState() {
    _readDifficulty();
    _readDifficultyIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Settings'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: height * 0.35,
              padding: EdgeInsets.fromLTRB(
                  width * 0.03, height * 0.01, width * 0.03, height * 0.01),
              child: Container(
                color: Colors.grey[350],
                child: Column(
                  children: <Widget>[
                    Container(
                      height: height * 0.04,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Game level: ",
                            style: TextStyle(
                              color: Colors.lightBlue[900],
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              "$chosenDifficulty",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.orange[900],
                                fontSize: width * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.29,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        itemCount: chosenButtonCheck.length,
                        itemBuilder: (_, i) => Container(
                          padding: EdgeInsets.fromLTRB(width * 0.01,
                              height * 0.002, width * 0.01, height * 0.002),
                          child: RaisedButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            elevation: 15,
                            color: Colors.lightBlue[900],
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                            textColor: chosenButtonCheck[i]
                                ? Colors.amber[900]
                                : Colors.white,
                            child: Text(
                              chosenButtonDifficulties[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                chosenButtonCheck = [];

                                for (var i = 0;
                                    i < chosenButtonDifficulties.length;
                                    i++) {
                                  chosenButtonCheck.add(false);
                                }

                                chosenButtonCheck[i] = true;
                                chosenIndex = i;

                                updateDifficulty(
                                  chosenButtonDifficulties[i],
                                );
                                resetChosenButtonCheck(chosenButtonCheck);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: height * 0.1,
              padding: EdgeInsets.fromLTRB(
                  width * 0.03, height * 0.01, width * 0.03, height * 0.01),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                    padding: EdgeInsets.all(5),
                    elevation: 15,
                    color: Colors.lightBlue[900],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    textColor: Colors.white,
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.06,
                      ),
                    ),
                    onPressed: () {
                      _saveDifficulty();
                      _saveDifficultyIndex();
                      Navigator.of(context).pop();
                    }),
              ),
            ),
            Container(
              height: height * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
