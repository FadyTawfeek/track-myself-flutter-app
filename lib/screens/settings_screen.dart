import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/providers/defaultMedication_class.dart';
import 'package:uuid/uuid.dart';
import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;
//import '../widgets/app_drawer.dart';

class Ids {
  final String id1 = Uuid().v1();
  final String id2 = Uuid().v1();
  final String id3 = Uuid().v1();
  final String id4 = Uuid().v1();
  final String id5 = Uuid().v1();
  final String id6 = Uuid().v1();
  final String id7 = Uuid().v1();
  final String id8 = Uuid().v1();
}

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String chosenDifficulty;
  int chosenIndex;
  //= "Easy (1 second)";
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
      //_nameChanged = true;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  //String value;
  _saveDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();
    //final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_diff_key';
    //final value = 42;
    difficultyPreference.setString(key, chosenDifficulty);
    //difficultyPreferenceIndex.setInt(key, chosenIndex);
    //print('saved $chosenDifficulty');
  }

  Future<void> _readDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();
    //final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_diff_key';
    final value = difficultyPreference.getString(key) ?? "Easy (0.5 seconds)";
    //print(value);
    //final indexValue = difficultyPreferenceIndex.getInt(key) ?? 0;
    //print('read: $value');
    setState(() {
      chosenDifficulty = value;
      //print(chosenDifficulty);
      //chosenIndex = indexValue;
    });
  }

  _saveDifficultyIndex() async {
    final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_index_key';
    //final value = 42;
    difficultyPreferenceIndex.setInt(key, chosenIndex);
    //difficultyPreferenceIndex.setInt(key, chosenIndex);
    //print('saved $chosenDifficulty');
  }

  Future<void> _readDifficultyIndex() async {
    final difficultyPreferenceIndex = await SharedPreferences.getInstance();
    final key = 'my_index_key';
    final value = difficultyPreferenceIndex.getInt(key) ?? 0;
    //print(value);
    //final indexValue = difficultyPreferenceIndex.getInt(key) ?? 0;
    //print('read: $value');
    setState(() {
      chosenIndex = value;
      chosenButtonCheck[chosenIndex] = true;
      //print(chosenDifficulty);
      //chosenIndex = indexValue;
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
      //drawer: AppDrawer(),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: height * 0.35,
              //width: width,
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

                        // mainAxisAlignment:
                        //     MainAxisAlignment.center,
                        // mainAxisAlignment:
                        //     MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Game level: ",
                            style: TextStyle(
                              color: Colors.lightBlue[900],
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //),
                          // FittedBox(
                          //   fit: BoxFit.fitWidth,
                          //child:
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
                          //),
                        ],
                      ),
                    ),
                    Container(
                      height: height * 0.29,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        // gridDelegate:
                        //     SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 3,
                        //   childAspectRatio: width / (height / 3.5),
                        // ),
                        itemCount: chosenButtonCheck.length,
                        // Row(
                        //   //crossAxisAlignment: CrossAxisAlignment.max,
                        //   //mainAxisSize: MainAxisSize.max,
                        //   mainAxisSize: MainAxisSize.max,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: <Widget>[
                        itemBuilder: (_, i) => Container(
                          //width: width * 0.9 / widget.defaultMedicationsData.length,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.01,
                              //75 / widget.defaultMedicationsData.length,
                              height * 0.002,
                              width * 0.01,
                              //75 / widget.defaultMedicationsData.length,
                              height * 0.002),
                          child: RaisedButton(
                            //padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            //padding: EdgeInsets.all(5),
                            elevation: 15,
                            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                            // child: FittedBox(
                            //   fit: BoxFit.fitWidth,
                            // child: Flexible(
                            //   fit: FlexFit.loose,
                            child: Text(
                              chosenButtonDifficulties[i],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                //fontSize: width*0.05,
                              ),
                            ),
                            //),
                            //),
                            onPressed: () {
                              setState(() {
                                // chosenButtonCheck[
                                //     (i - 1) % widget.defaultMedicationsData.length] = false;
                                // chosenButtonCheck[
                                //     (i + 1) % widget.defaultMedicationsData.length] = false;
                                chosenButtonCheck = [];
                                //chosenButtonCheck = [];

                                for (var i = 0;
                                    i < chosenButtonDifficulties.length;
                                    i++) {
                                  chosenButtonCheck.add(false);
                                }
                                //print(chosenButtonCheck);
                                chosenButtonCheck[i] = true;
                                chosenIndex = i;
                                //print(chosenButtonCheck);

                                updateDifficulty(
                                  chosenButtonDifficulties[i],
                                );
                                resetChosenButtonCheck(chosenButtonCheck);
                                //widget.asyncStuff2();
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
              //width: width,
              padding: EdgeInsets.fromLTRB(
                  width * 0.03, height * 0.01, width * 0.03, height * 0.01),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: RaisedButton(
                    padding: EdgeInsets.all(5),
                    elevation: 15,
                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.lightBlue[900],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid),
                    ),
                    textColor: Colors.white,
                    // child: FittedBox(
                    //   fit: BoxFit.fitWidth,
                    // child: Flexible(
                    //   fit: FlexFit.loose,
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
        // child: Container(
        //   height: height * 0.15,
        //   //width: width,
        //   padding: EdgeInsets.fromLTRB(
        //       width * 0.03, height * 0.01, width * 0.03, height * 0.01),
        //   child: Container(
        //     color: Colors.grey[350],
        //     child: Column(
        //       children: <Widget>[
        //         Container(
        //           height: height * 0.04,
        //           padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.max,

        //             // mainAxisAlignment:
        //             //     MainAxisAlignment.center,
        //             // mainAxisAlignment:
        //             //     MainAxisAlignment.spaceEvenly,
        //             children: [
        //               Text(
        //                 "Chosen difficulty: ",
        //                 style: TextStyle(
        //                   color: Colors.lightBlue[900],
        //                   fontSize: width * 0.05,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               //),
        //               // FittedBox(
        //               //   fit: BoxFit.fitWidth,
        //               //child:
        //               Flexible(
        //                 fit: FlexFit.loose,
        //                 child: Text(
        //                   "$chosenDifficulty",
        //                   overflow: TextOverflow.ellipsis,
        //                   style: TextStyle(
        //                     color: Colors.orange[900],
        //                     fontSize: width * 0.05,
        //                   ),
        //                 ),
        //               ),
        //               //),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // Column(
        //   children: [
        //     TextFormField(
        //       //initialValue: "",
        //       // decoration: InputDecoration(
        //       //     labelText: 'Name'),
        //       textInputAction: TextInputAction.done,
        //       //onFieldSubmitted: (_) {
        //       //FocusScope.of(context).requestFocus(_priceFocusNode);
        //       //},
        //       validator: (value) {
        //         if (value.isEmpty) {
        //           return 'Please provide a value.';
        //         }
        //         return null;
        //       },
        //       onChanged: (newValue) {
        //         setState(() {
        //           value = newValue;
        //         });
        //       },
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: RaisedButton(
        //         child: Text('Save'),
        //         onPressed: () {
        //           _save();
        //         },
        //       ),
        //     ),
        //   ],
        //   //child: Text('My info body'),
        // ),
      ),
    );
  }
}
