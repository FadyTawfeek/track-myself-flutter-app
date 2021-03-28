import 'dart:async';
import 'dart:core';
//import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/providers/normalMedicationGroups_class.dart';
import 'package:stop1/widgets/medication_groups_names_buttons.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
//import '../widgets/medication_names_buttons.dart';
//import '../widgets/optimal_times_buttons.dart';
//import '../providers/normalMedication_class.dart';
import '../providers/defaultMedication_class.dart';
//import '../providers/defaultMedication_class.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';
//import '../screens/my_home_page.dart';
import '../screens/addSymptom_screen.dart';
import '../screens/more_screen.dart';
import 'addNormalMedication_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:math';
// import 'package:uuid/uuid.dart';

// enum SymptomOptions {
//   No_symptoms,
//   Light_symptoms,
//   Mild_symptoms,
//   Strong_symptoms,
//   Severe_symptoms,
// }

class AddNormalMedicationGroupScreen extends StatefulWidget {
  static const routeName = '/add-normal-medication-group';

  AddNormalMedicationGroupScreen({Key key}) : super(key: key);

  @override
  _AddNormalMedicationGroupScreenState createState() =>
      _AddNormalMedicationGroupScreenState();
}

class _AddNormalMedicationGroupScreenState
    extends State<AddNormalMedicationGroupScreen> {
  //String _selectedSymptom = "No symptoms";
  FlutterLocalNotificationsPlugin fltrNotification;

  var _isInit = true;
  var _isLoading = true;
  var _internet = false;

  void updateName(String newName) {
    setState(() {
      _name = newName;
      //_nameChanged = true;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  // void resetChosenButtonCheck2(List newList) {
  //   setState(() {
  //     chosenButtonCheck2 = newList;
  //   });
  // }

  void updateOptimalTime(String newName) {
    setState(() {
      _optimalTime = newName;
    });
  }

  // void _nameChangedReset(String unNeeded) {
  //   setState(() {
  //     _nameChanged = false;
  //   });
  // }

  // List<DefaultMedicationItem> defaultMedicationsDataForButtons = [
  //   DefaultMedicationItem(
  //       id: "1", default_med_name: "Loading ...", amount: "1"),
  // ];
  List<String> medicationNames = [];
  String _name = "Loading ...";
  //bool _nameChanged = false;
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
    // setState(() {
    //   medicationOptimalTimes = [];
    // });
    setState(() {
      _optimalTime = null;
    });

    await Provider.of<DefaultMedicationsGroups>(context, listen: false)
        .findByName(_name);
    final defaultMedicationsGroupsData =
        Provider.of<DefaultMedicationsGroups>(context, listen: false);
    //print(defaultMedicationsData.items3[0].default_time1);
    setState(() {
      //medicationOptimalTimes = [];
      _optimalTime = defaultMedicationsGroupsData.items3[0].default_time;
      theFinalList = defaultMedicationsGroupsData.items
          .firstWhere((element) => element.default_group_name == _name)
          .listOfMedicationItems;

      // setState(() {
      //   //_optimalTime = medicationOptimalTimes[0];
      // });
    });
  }

  Future<void> _asyncStuff() async {
    // setState(() {
    //   _isLoading = true;
    // });
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
      //print("object");

      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .fetchDefaultMedicationsGroups();
      //print("object2");

      final defaultMedicationsGroupsData =
          Provider.of<DefaultMedicationsGroups>(context, listen: false);

      chosenButtonCheck = [];

      for (var i = 0; i < defaultMedicationsGroupsData.items.length; i++) {
        chosenButtonCheck.add(false);
      }

      defaultMedicationsGroupsDataForButtons =
          defaultMedicationsGroupsData.items;
      //print(defaultMedicationsGroupsDataForButtons[0].default_group_name);

      //if (defaultMedicationsData.items.isNotEmpty) {
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

      //########
      //int optimalTimeIndex = 0;

      // await Provider.of<DefaultMedicationsGroups>(context, listen: false)
      //     .fetchAndSortDefaultMedicationsGroups();

      // final sortedDefaultMedicationsGroupsData =
      //     Provider.of<DefaultMedicationsGroups>(context, listen: false)
      //         .sortedList;

      // NormalMedicationGroup lastNormalMedicationGroup;

      // await Provider.of<NormalMedicationsGroups>(context, listen: false)
      //     .fetchNormalMedicationsGroups();

      // final checkThereIsNormalMedicationsGroups =
      //     Provider.of<NormalMedicationsGroups>(context, listen: false).items;
      // //print(checkThereIsNormalMedicationsGroups);
      // //print("object");

      // //print("aaaaaa$checkThereIsNormalMedications");
      // if (checkThereIsNormalMedicationsGroups.isNotEmpty) {
      //   lastNormalMedicationGroup =
      //       Provider.of<NormalMedicationsGroups>(context, listen: false)
      //           .items
      //           .last;
      // }
      // //print(lastNormalMedicationGroup);

      // for (var i = 0; i < sortedDefaultMedicationsGroupsData.length; i++) {
      //   if (lastNormalMedicationGroup != null &&
      //       lastNormalMedicationGroup.normal_group_name ==
      //           sortedDefaultMedicationsGroupsData[i].default_group_name &&
      //       lastNormalMedicationGroup.optimal_time ==
      //           sortedDefaultMedicationsGroupsData[i].time) {
      //     setState(() {
      //       nextToBeDisplayedMedicationGroupName =
      //           sortedDefaultMedicationsGroupsData[
      //                   (i + 1) % sortedDefaultMedicationsGroupsData.length]
      //               .default_group_name;

      //       //print(nextToBeDisplayedMedicationName);

      //       nextToBeDisplayedMedicationGroupTime =
      //           sortedDefaultMedicationsGroupsData[
      //                   (i + 1) % sortedDefaultMedicationsGroupsData.length]
      //               .time;

      //       //print(nextToBeDisplayedMedicationTime);
      //     });
      //     break;
      //   }
      // }

      // if (nextToBeDisplayedMedicationGroupName != null) {
      //   setState(() {
      //     nameIndex = medicationNames.indexWhere(
      //         (element) => element == nextToBeDisplayedMedicationGroupName);
      //     //print(nameIndex);
      //   });
      // }

      //########

      setState(() {
        if (medicationNames.isNotEmpty) {
          _name = medicationNames[nameIndex];
        }
        chosenButtonCheck[nameIndex] = true;
      });

      // setState(() {
      //   //print(nameIndex);
      // });

      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .findByName(_name);
      // final defaultMedicationsGroupsDataa =
      //     Provider.of<DefaultMedicationsGroups>(context, listen: false);
      //print(defaultMedicationsData.items3[0].default_time1);
      setState(() {
        //medicationOptimalTimes = [];
        _optimalTime = defaultMedicationsGroupsData.items3[0].default_time;
        theFinalList = defaultMedicationsGroupsData.items
            .firstWhere((element) => element.default_group_name == _name)
            .listOfMedicationItems;
        //print(theFinalList);
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

  // List<bool> chosenButtonCheck2 = [
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  //   false,
  // ];

  //var a = TimeOfDay.fromDateTime(DateTime.now()).toString();
  List<String> medicationOptimalTimes = [];

  String _optimalTime = "Loading ...";
  //String _chosenOptimalTime;

  String _takenTime;
  // String _time3;
  // String _time4;
  // String _time5;

  bool _timeValidator = true;
  bool _dateValidator = true;
  bool _nameValidator = true;

  DateTime _takenDateTime = DateTime.now();
  //bool _timeValidator = true;

  // List<TimeOfDay> timeList = [
  //   time11,

  //   '_time2',
  //   '_time3',
  //   '_time4',
  //   '_time5',
  // ];

  //C [0] = "12";

  int _numPills = 1;

  Future<void> _saveForm(
      _name, _takenDateTime, _optimalTime, _takenTime, _numPills) async {
    // final isValid = _form.currentState.validate();
    // if (!isValid) {
    //   return;
    // }

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

    // if (_takenTime == null) {
    //   setState(() {
    //     _timeValidator = false;
    //   });
    //   return;
    // }

    var normalMedicationGroup = NormalMedicationGroup(
      id: Uuid().v1(),
      normal_group_name: _name,
      optimal_time: _optimalTime,
      taken_dateTime: _takenDateTime,
      listOfMedicationItems: theFinalList,
    );
    //_newNormalMedication =
    //normalMedicationItem;
    //_form.currentState.save();
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
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }
    setState(() {
      //_isLoading = false;
    });
    // tz.initializeTimeZones();

    // var androidInitilize = new AndroidInitializationSettings('app_icon');
    // var iOSinitilize = new IOSInitializationSettings();
    // var initilizationsSettings = new InitializationSettings(
    //     android: androidInitilize, iOS: iOSinitilize);
    // fltrNotification = new FlutterLocalNotificationsPlugin();
    // fltrNotification.initialize(initilizationsSettings,
    //     onSelectNotification: notificationSelected);
    // await showDailyAtTime();
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  // Future notificationSelected(String payload) async {
  //   // showDialog(
  //   //   context: context,
  //   //   builder: (context) => AlertDialog(
  //   //     content: Text("Notification : $payload"),
  //   //   ),
  //   // );
  //   print("a");
  //   Navigator.of(context).pushNamed(
  //     AddNormalMedicationGroupScreen.routeName,
  //   );
  // }

  // Future<void> showDailyAtTime() async {
  //   final String currentTimeZone =
  //       await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(currentTimeZone));

  //   //var time = Time(02, 45, 00);

  //   var androidDetails = new AndroidNotificationDetails("id", "a", "b",
  //       importance: Importance.max);
  //   var iSODetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //       new NotificationDetails(android: androidDetails, iOS: iSODetails);

  //   await fltrNotification.zonedSchedule(
  //       Random().nextInt(100),
  //       "take",
  //       "medication",
  //       tz.TZDateTime.local(2050, 01, 01, 21, 29),
  //       generalNotificationDetails,
  //       uiLocalNotificationDateInterpretation: null,
  //       androidAllowWhileIdle: true,
  //       matchDateTimeComponents: DateTimeComponents.time);
  //   print("started daily reminders for a normal medication");
  //   //DateTimeComponents.matchTime

  //   // await fltrNotification.showDailyAtTime(0, "Daily survey",
  //   //     "Remember to fill your daily survey", time, generalNotificationDetails);
  // }

  Future<void> _presentDateTimePicker() async {
    await DatePicker.showDateTimePicker(
      context, maxTime: DateTime.now(),

      // context: context,
      // initialDate: DateTime.now(),
      // firstDate: DateTime(2019),
      // lastDate: DateTime.now(),
    ).then((pickedDateTime) {
      if (pickedDateTime == null) {
        return null;
      }
      setState(() {
        _takenDateTime = pickedDateTime;
        //.toString().substring(10, 15);
        //_time1 = time;
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

  //final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      //key: _scaffoldKey,
      bottomNavigationBar: MedicationsBottomBar(height, width),
      //drawer: AppDrawer(),
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
                      //Divider(),
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
                              //width: width,
//                        child: Container(
                              // child: Form(
                              //   key: _form,
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    height: height * 0.38,
                                    //width: width,
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

                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceEvenly,
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
                                                //),
                                                // FittedBox(
                                                //   fit: BoxFit.fitWidth,
                                                //child:
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
                                                //),
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
                                                  //medicationNames[0],
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
                                  //Center(child: Text("Date taken")),
                                  //Divider(),
                                  Container(
                                    height: height * 0.15,
                                    //width: width,
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
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceEvenly,
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
                                                //),
                                                // FittedBox(
                                                //   fit: BoxFit.fitWidth,
                                                //child:
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
                                                //),
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
                                                    //color: Colors.lightBlue[900],
                                                    fontSize: width * 0.04,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                // Text(
                                                //   _takenDateTime == null
                                                //       ? 'No Date Chosen!'
                                                //       : "Picked Date and time: $_takenDateTime",
                                                //   //"Picked Date and time: ${DateFormat("dd-MM-yyyy").format(_takenDateTime)}",
                                                // ),
                                                RaisedButton(
                                                    padding: EdgeInsets.all(5),
                                                    elevation: 15,
                                                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                                    // child: FittedBox(
                                                    //   fit: BoxFit.fitWidth,
                                                    // child: Flexible(
                                                    //   fit: FlexFit.loose,
                                                    child: Text(
                                                      'Choose different Date and time',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        //fontSize: width*0.05,
                                                      ),
                                                    ),
                                                    //),
                                                    //),
                                                    onPressed: () {
                                                      //_presentDateTimePicker;
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
                                    //width: width,
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
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.center,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceEvenly,
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
                                                //),
                                                // FittedBox(
                                                //   fit: BoxFit.fitWidth,
                                                //child:
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

                                                  // Text(
                                                  //   "${DateFormat("dd-MM-yyyy '@' hh:mm").format(_takenDateTime)}",
                                                  //   style: TextStyle(
                                                  //     color: Colors.orange[900],
                                                  //     fontSize: width * 0.05,
                                                  //   ),
                                                  // ),
                                                ),
                                                //),
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
                                                    //color: Colors.lightBlue[900],
                                                    fontSize: width * 0.04,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                // Text(
                                                //   _takenDateTime == null
                                                //       ? 'No Date Chosen!'
                                                //       : "Picked Date and time: $_takenDateTime",
                                                //   //"Picked Date and time: ${DateFormat("dd-MM-yyyy").format(_takenDateTime)}",
                                                // ),
                                                RaisedButton(
                                                    padding: EdgeInsets.all(5),
                                                    elevation: 15,
                                                    //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                                    // child: FittedBox(
                                                    //   fit: BoxFit.fitWidth,
                                                    // child: Flexible(
                                                    //   fit: FlexFit.loose,
                                                    child: Text(
                                                      'Add booster instead',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        //fontSize: width*0.05,
                                                      ),
                                                    ),
                                                    //),
                                                    //),
                                                    onPressed: () {
                                                      //_presentDateTimePicker;
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                              AddNormalMedicationScreen
                                                                  .routeName);
                                                      // setState(() {
                                                      //   pickTimeFlag = true;
                                                      //   _presentDateTimePicker();
                                                      // });
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
                                    //width: width,
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
                                          'Submit',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.06,
                                          ),
                                        ),
                                        //),
                                        //),
                                        onPressed: () => _saveForm(
                                            _name,
                                            _takenDateTime,
                                            _optimalTime,
                                            _takenTime,
                                            _numPills),
                                      ),
                                    ),
                                  ),

                                  // Padding(
                                  //   padding: EdgeInsets.all(8),
                                  //   // child: ListView.builder(
                                  //   //   itemCount: _numOfTimes,
                                  //   //   //_numOfTimes
                                  //   //   itemBuilder: (_, i) =>
                                  //   child: Column(
                                  //     children: <Widget>[
                                  //       Center(
                                  //         child: Text("Date and time: "),
                                  //       ),
                                  //       Text(
                                  //         _takenDateTime == null
                                  //             ? 'No Date Chosen!'
                                  //             : "Picked Date and time: $_takenDateTime",
                                  //         //"Picked Date and time: ${DateFormat("dd-MM-yyyy").format(_takenDateTime)}",
                                  //       ),
                                  //       FlatButton(
                                  //         onPressed: _presentDateTimePicker,
                                  //         child:
                                  //             Text('Choose different Date and time'),
                                  //       ),
                                  //       Divider(),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SingleChildScrollView(
                                  //   child: Container(
                                  //     //height: 180,
                                  //     width: double.infinity,
                                  //     child: Column(
                                  //       children: <Widget>[
                                  //         if (_timeValidator == false)
                                  //           Text(
                                  //             "Please input the missing time",
                                  //             style: TextStyle(
                                  //                 fontWeight: FontWeight.bold,
                                  //                 color: Colors.red),
                                  //           ),
                                  //         Padding(
                                  //           padding: EdgeInsets.all(8),
                                  //           // child: ListView.builder(
                                  //           //   itemCount: _numOfTimes,
                                  //           //   //_numOfTimes
                                  //           //   itemBuilder: (_, i) =>
                                  //           child: Column(
                                  //             children: <Widget>[
                                  //               Center(
                                  //                 child: Text("Optimal time: "),
                                  //               ),
                                  //               //// OptimalTimesButtons(
                                  //               ////   medicationOptimalTimes,
                                  //               ////   updateOptimalTime,
                                  //               ////   _nameChanged,
                                  //               ////   _nameChangedReset,
                                  //               ////   chosenButtonCheck2,
                                  //               ////   resetChosenButtonCheck2,
                                  //               //// ),

                                  //               // DropdownButton<String>(
                                  //               //   value: _optimalTime,
                                  //               //   icon: Icon(Icons.arrow_downward),
                                  //               //   iconSize: 24,
                                  //               //   elevation: 16,
                                  //               //   style: TextStyle(
                                  //               //       color: Colors.deepPurple),
                                  //               //   underline: Container(
                                  //               //     height: 2,
                                  //               //     color: Colors.deepPurpleAccent,
                                  //               //   ),
                                  //               //   onChanged: (String newValue) {
                                  //               //     setState(() {
                                  //               //       _optimalTime = newValue;
                                  //               //     });
                                  //               //   },
                                  //               //   hint: Text("Select optimal time"),
                                  //               //   items: medicationOptimalTimes
                                  //               //       .map<DropdownMenuItem<String>>(
                                  //               //           (String value) {
                                  //               //     return DropdownMenuItem<String>(
                                  //               //       value: value,
                                  //               //       child: Text(value),
                                  //               //     );
                                  //               //   }).toList(),
                                  //               // ),
                                  //               Text(
                                  //                 _optimalTime == null
                                  //                     ? 'Loading ...'
                                  //                     : "$_optimalTime",
                                  //               ),
                                  //               Divider(),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //         //if (_numOfTimes == 2)
                                  //         // Padding(
                                  //         //   padding: EdgeInsets.all(8),
                                  //         //   // child: ListView.builder(
                                  //         //   //   itemCount: _numOfTimes,
                                  //         //   //   //_numOfTimes
                                  //         //   //   itemBuilder: (_, i) =>
                                  //         //   child: Column(
                                  //         //     children: <Widget>[
                                  //         //       Center(
                                  //         //         child: Text("taken time: "),
                                  //         //       ),
                                  //         //       FlatButton(
                                  //         //         onPressed: _presentTimePicker2,
                                  //         //         // () {
                                  //         //         //   setState(() {
                                  //         //         //     //_time2 = _presentTimePicker();
                                  //         //         //   });
                                  //         //         // },
                                  //         //         child: Text('Choose Time'),
                                  //         //       ),
                                  //         //       FlatButton(
                                  //         //         onPressed: _nowTime,
                                  //         //         child: Text("Now"),
                                  //         //       ),
                                  //         //       Text(
                                  //         //         _takenTime == null
                                  //         //             ? 'No Time Chosen!'
                                  //         //             : "Picked Time: $_takenTime",
                                  //         //       ),
                                  //         //       // if (_timeValidator == false)
                                  //         //       //   _displaySnackBar(context),
                                  //         //       Divider(),
                                  //         //     ],
                                  //         //   ),
                                  //         // ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  // InkWell(
                                  //   onTap: () => Navigator.of(context).pushNamed(
                                  //       AddNormalMedicationScreen.routeName),
                                  //   child: Card(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(15),
                                  //     ),
                                  //     elevation: 4,
                                  //     margin: EdgeInsets.all(10),
                                  //     child: Column(
                                  //       children: <Widget>[
                                  //         Positioned(
                                  //           bottom: 20,
                                  //           right: 10,
                                  //           child: Container(
                                  //             width: 150,
                                  //             color: Colors.blue,
                                  //             padding: EdgeInsets.symmetric(
                                  //               vertical: 5,
                                  //               horizontal: 20,
                                  //             ),
                                  //             child: Text(
                                  //               'booster ?',
                                  //               textAlign: TextAlign.center,
                                  //               style: TextStyle(
                                  //                 fontSize: 26,
                                  //                 color: Colors.white,
                                  //               ),
                                  //               softWrap: true,
                                  //               overflow: TextOverflow.fade,
                                  //             ),
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              //),
                              //),
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
                      //disabledColor: Colors.blue,
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
                      //disabledColor: Colors.blue,
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
