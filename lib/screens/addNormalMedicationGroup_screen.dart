import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/providers/normalMedicationGroups_class.dart';
import 'package:stop1/widgets/medication_groups_names_buttons.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
import '../providers/defaultMedication_class.dart';
import 'package:intl/intl.dart';
import '../screens/addSymptom_screen.dart';
import '../screens/more_screen.dart';
import 'addNormalMedication_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddNormalMedicationGroupScreen extends StatefulWidget {
  static const routeName = '/add-normal-medication-group';

  AddNormalMedicationGroupScreen({Key key}) : super(key: key);

  @override
  _AddNormalMedicationGroupScreenState createState() =>
      _AddNormalMedicationGroupScreenState();
}

class _AddNormalMedicationGroupScreenState
    extends State<AddNormalMedicationGroupScreen> {
  FlutterLocalNotificationsPlugin fltrNotification;

  var _isInit = true;
  var _isLoading = true;
  var _internet = false;

  void updateName(String newName) {
    setState(() {
      _name = newName;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  void updateOptimalTime(String newName) {
    setState(() {
      _optimalTime = newName;
    });
  }

  List<String> medicationNames = [];
  String _name = "Loading ...";

  bool pressed1 = true;
  bool pressed2 = false;
  List<DefaultMedicationItem> theFinalList = [];
  List<DefaultMedicationGroup> defaultMedicationsGroupsDataForButtons = [
    DefaultMedicationGroup(
        id: "1",
        default_group_name: "Loading ...",
        default_time: "1",
        listOfMedicationItems: [
          DefaultMedicationItem(
              id: "1", default_med_name: "Loading ...", amount: "1"),
        ]),
  ];

  Future<void> _refreshAddNormalMedicationGroup(BuildContext context) async {
    await Provider.of<NormalMedicationsGroups>(context, listen: false)
        .fetchNormalMedicationsGroups();
  }

  String nextToBeDisplayedMedicationGroupName;
  String nextToBeDisplayedMedicationGroupTime;

  Future<void> _asyncStuff2() async {
    setState(() {
      _optimalTime = null;
    });

    await Provider.of<DefaultMedicationsGroups>(context, listen: false)
        .findByName(_name);
    final defaultMedicationsGroupsData =
        Provider.of<DefaultMedicationsGroups>(context, listen: false);

    setState(() {
      _optimalTime = defaultMedicationsGroupsData.items3[0].default_time;
      theFinalList = defaultMedicationsGroupsData.items
          .firstWhere((element) => element.default_group_name == _name)
          .listOfMedicationItems;
    });
  }

  Future<void> _asyncStuff() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty) {
        setState(() {
          _internet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _internet = false;
      });
    }
    if (_isInit && _internet) {
      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .fetchDefaultMedicationsGroups();

      final defaultMedicationsGroupsData =
          Provider.of<DefaultMedicationsGroups>(context, listen: false);

      chosenButtonCheck = [];

      for (var i = 0; i < defaultMedicationsGroupsData.items.length; i++) {
        chosenButtonCheck.add(false);
      }

      defaultMedicationsGroupsDataForButtons =
          defaultMedicationsGroupsData.items;

      for (var i = 0; i < defaultMedicationsGroupsData.items.length; i++) {
        medicationNames
            .add(defaultMedicationsGroupsData.items[i].default_group_name);
      }

      int nameIndex = 0;

      if (defaultMedicationsGroupsData.items.isEmpty) {
        setState(() {
          noDefaultMedGroups = true;
          _isLoading = false;
          _isInit = false;
        });
      }

      setState(() {
        if (medicationNames.isNotEmpty) {
          _name = medicationNames[nameIndex];
        }
        chosenButtonCheck[nameIndex] = true;
      });

      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .findByName(_name);

      setState(() {
        _optimalTime = defaultMedicationsGroupsData.items3[0].default_time;
        theFinalList = defaultMedicationsGroupsData.items
            .firstWhere((element) => element.default_group_name == _name)
            .listOfMedicationItems;
      });
    }
    setState(() {
      _isLoading = false;
      _isInit = false;
    });
  }

  List<bool> chosenButtonCheck = [false];
  bool pickTimeFlag = false;
  bool noDefaultMedGroups = false;

  List<String> medicationOptimalTimes = [];

  String _optimalTime = "Loading ...";

  String _takenTime;

  bool _timeValidator = true;
  bool _dateValidator = true;
  bool _nameValidator = true;

  DateTime _takenDateTime = DateTime.now();

  int _numPills = 1;

  Future<void> _saveForm(
      _name, _takenDateTime, _optimalTime, _takenTime, _numPills) async {
    if (_name == null) {
      setState(() {
        _nameValidator = false;
      });
      return;
    }

    if (_takenDateTime == null) {
      setState(() {
        _dateValidator = false;
      });
      return;
    }

    if (_optimalTime == null) {
      setState(() {
        _timeValidator = false;
      });
      return;
    }

    var normalMedicationGroup = NormalMedicationGroup(
      id: Uuid().v1(),
      normal_group_name: _name,
      optimal_time: _optimalTime,
      taken_dateTime: _takenDateTime,
      listOfMedicationItems: theFinalList,
    );

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<NormalMedicationsGroups>(context, listen: false)
          .addNormalMedicationGroup(normalMedicationGroup);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    setState(() {});

    Navigator.of(context).pop();
  }

  Future<void> _presentDateTimePicker() async {
    await DatePicker.showDateTimePicker(
      context,
      maxTime: DateTime.now(),
    ).then((pickedDateTime) {
      if (pickedDateTime == null) {
        return null;
      }
      setState(() {
        _takenDateTime = pickedDateTime;
      });
    });
  }

  void _nowTime() {
    setState(() {
      var time = TimeOfDay.now().toString().substring(10, 15);
      _takenTime = time;
    });
  }

  Future<void> _presentTimePicker2() async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return null;
      }
      setState(() {
        var time = pickedTime.toString().substring(10, 15);
        _takenTime = time;
      });
    });
  }

  @override
  void initState() {
    _asyncStuff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Add Medication group'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    if (_name != null) {
      setState(() {
        _nameValidator = true;
      });
    }

    if (_takenDateTime != null) {
      setState(() {
        _dateValidator = true;
      });
    }

    if (_optimalTime != null && _takenTime != null) {
      setState(() {
        _timeValidator = true;
      });
    }

    return Scaffold(
      bottomNavigationBar: MedicationsBottomBar(height, width),
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : noDefaultMedGroups
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "No doctor medications or medication groups are added, please ask the doctor to add them from 'More' menu.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                    ],
                  )
                : Container(
                    child: _internet
                        ? RefreshIndicator(
                            onRefresh: () =>
                                _refreshAddNormalMedicationGroup(context),
                            child: Container(
                              height: height * 0.8,
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    height: height * 0.38,
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.03,
                                        height * 0.01,
                                        width * 0.03,
                                        height * 0.01),
                                    child: Container(
                                      color: Colors.grey[350],
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: height * 0.04,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Medication group name: ",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900],
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text(
                                                    "$_name",
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                            height: height * 0.32,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                MedicationGroupsNamesButtons(
                                                  defaultMedicationsGroupsDataForButtons,
                                                  updateName,
                                                  _asyncStuff2,
                                                  chosenButtonCheck,
                                                  resetChosenButtonCheck,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_dateValidator == false)
                                    Text(
                                      "Please input the missing date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  Container(
                                    height: height * 0.15,
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.03,
                                        height * 0.01,
                                        width * 0.03,
                                        height * 0.01),
                                    child: Container(
                                      color: Colors.grey[350],
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: height * 0.04,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Date and time: ",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900],
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text(
                                                    "${DateFormat("dd-MM-yyyy '@' HH:mm").format(_takenDateTime)}",
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
                                            height: height * 0.09,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  "Not now ? ",
                                                  style: TextStyle(
                                                    fontSize: width * 0.04,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                RaisedButton(
                                                    padding: EdgeInsets.all(5),
                                                    elevation: 15,
                                                    color:
                                                        Colors.lightBlue[900],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 2,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                    textColor: pickTimeFlag
                                                        ? Colors.amber[900]
                                                        : Colors.white,
                                                    child: Text(
                                                      'Choose different Date and time',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        pickTimeFlag = true;
                                                        _presentDateTimePicker();
                                                      });
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.15,
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.03,
                                        height * 0.01,
                                        width * 0.03,
                                        height * 0.01),
                                    child: Container(
                                      color: Colors.grey[350],
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: height * 0.04,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "Optimal time is: ",
                                                  style: TextStyle(
                                                    color:
                                                        Colors.lightBlue[900],
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Flexible(
                                                  fit: FlexFit.loose,
                                                  child: Text(
                                                    _optimalTime == null
                                                        ? 'Loading ...'
                                                        : "$_optimalTime",
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
                                            height: height * 0.09,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  "Not right ? ",
                                                  style: TextStyle(
                                                    fontSize: width * 0.04,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                RaisedButton(
                                                    padding: EdgeInsets.all(5),
                                                    elevation: 15,
                                                    color:
                                                        Colors.lightBlue[900],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors.black,
                                                          width: 2,
                                                          style: BorderStyle
                                                              .solid),
                                                    ),
                                                    textColor: Colors.white,
                                                    child: Text(
                                                      'Add booster instead',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              AddNormalMedicationScreen
                                                                  .routeName);
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.03,
                                        height * 0.01,
                                        width * 0.03,
                                        height * 0.01),
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                          'Submit',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.06,
                                          ),
                                        ),
                                        onPressed: () => _saveForm(
                                            _name,
                                            _takenDateTime,
                                            _optimalTime,
                                            _takenTime,
                                            _numPills),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : NoInternet(AddNormalMedicationGroupScreen.routeName),
                  ),
      ),
    );
  }
}

class MedicationsBottomBar extends StatelessWidget {
  final height;
  final width;
  MedicationsBottomBar(this.height, this.width);
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
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.assignment_return,
                            color: Colors.amber[900],
                          ),
                          Text(
                            "Medication",
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
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
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
