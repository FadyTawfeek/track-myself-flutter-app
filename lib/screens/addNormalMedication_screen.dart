import 'dart:async';
import 'dart:core';
//import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
import '../widgets/medication_names_buttons.dart';
//import '../widgets/optimal_times_buttons.dart';
import '../providers/normalMedication_class.dart';
import '../providers/defaultMedication_class.dart';
//import '../providers/defaultMedication_class.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import '../screens/my_home_page.dart';
import '../screens/addSymptom_screen.dart';
import '../screens/more_screen.dart';
// import 'package:uuid/uuid.dart';

// enum SymptomOptions {
//   No_symptoms,
//   Light_symptoms,
//   Mild_symptoms,
//   Strong_symptoms,
//   Severe_symptoms,
// }

class AddNormalMedicationScreen extends StatefulWidget {
  static const routeName = '/add-normal-medication';

  AddNormalMedicationScreen({Key key}) : super(key: key);

  @override
  _AddNormalMedicationScreenState createState() =>
      _AddNormalMedicationScreenState();
}

class _AddNormalMedicationScreenState extends State<AddNormalMedicationScreen> {
  final _form = GlobalKey<FormState>();
  //String _selectedSymptom = "No symptoms";

  var _isInit = true;
  var _isLoading = true;
  var _internet = false;

  void updateName(String newName) {
    setState(() {
      _name = newName;
      _nameChanged = true;
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

  void _nameChangedReset(String unNeeded) {
    setState(() {
      _nameChanged = false;
    });
  }

  Future<void> _refreshAddNormalMedications(BuildContext context) async {
    await Provider.of<NormalMedications>(context, listen: false)
        .fetchNormalMedications();
  }

  @override
  void initState() {
    _asyncStuff();
    super.initState();
  }

  String nextToBeDisplayedMedicationName;
  String nextToBeDisplayedMedicationTime;

  Future<void> _asyncStuff2() async {
    // setState(() {
    //   medicationOptimalTimes = [];
    // });
    // setState(() {
    //   _optimalTime = null;
    // });

    // await Provider.of<DefaultMedications>(context, listen: false)
    //     .findByName(_name);
    // final defaultMedicationsData =
    //     Provider.of<DefaultMedications>(context, listen: false);
    // //print(defaultMedicationsData.items3[0].default_time1);
    // setState(() {
    //   medicationOptimalTimes = [];

    //   setState(() {
    //     //_optimalTime = medicationOptimalTimes[0];
    //   });
    // });
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
      await Provider.of<DefaultMedications>(context, listen: false)
          .fetchDefaultMedications();

      final defaultMedicationsData =
          Provider.of<DefaultMedications>(context, listen: false);

      chosenButtonCheck = [];

      for (var i = 0; i < defaultMedicationsData.items.length; i++) {
        chosenButtonCheck.add(false);
      }

      // await Provider.of<DefaultMedications>(context, listen: false)
      //     .fetchAndSortDefaultMedications();

      // final sortedDefaultMedicationsData =
      //     Provider.of<DefaultMedications>(context, listen: false).sortedList;

      await Provider.of<NormalMedications>(context, listen: false)
          .fetchNormalMedications();

      // NormalMedicationItem lastNormalMedication;

      // final checkThereIsNormalMedications =
      //     Provider.of<NormalMedications>(context, listen: false).items;

      // //print("aaaaaa$checkThereIsNormalMedications");
      // if (checkThereIsNormalMedications.isNotEmpty) {
      //   lastNormalMedication =
      //       Provider.of<NormalMedications>(context, listen: false).items.last;
      // }

      //setState(() {});
      defaultMedicationsDataForButtons = defaultMedicationsData.items;

      //if (defaultMedicationsData.items.isNotEmpty) {
      for (var i = 0; i < defaultMedicationsData.items.length; i++) {
        medicationNames.add(defaultMedicationsData.items[i].default_med_name);
      }
      //}

      int nameIndex = 0;
      //int optimalTimeIndex = 0;

      // if (nextToBeDisplayedMedicationName != null) {
      //   setState(() {
      //     nameIndex = medicationNames.indexWhere(
      //         (element) => element == nextToBeDisplayedMedicationName);
      //     //print(nameIndex);
      //   });
      // }

      setState(() {
        if (medicationNames.isNotEmpty) {
          _name = medicationNames[nameIndex];
        }

        //print(_name);
        chosenButtonCheck[nameIndex] = true;
        // _optimalTime = nextToBeDisplayedMedicationTime;
        // //print(_optimalTime);
        // chosenButtonCheck2[optimalTimeIndex] = true;
      });

      // await Provider.of<DefaultMedications>(context, listen: false)
      //     .findByName(_name);

      //print("name is $_name");

      // setState(() {
      //   // _name = medicationNames[nameIndex];
      //   // print(_name);
      //   // chosenButtonCheck[nameIndex] = true;
      //   _optimalTime = nextToBeDisplayedMedicationTime;
      //   //print(_optimalTime);
      //   //chosenButtonCheck2[optimalTimeIndex] = true;
      // });

      //String now = TimeOfDay.now().toString().substring(10, 15);

      // int calculatedTimeDifference = 999999999;

      // int timeDifference = 0;

      // int nowHour = int.parse(now.substring(0, 2));
      // int nowMin = int.parse(now.substring(3));

      // for (var i = 0; i < defaultMedicationsData.items.length; i++) {
      //   timeDifference = (nowHour -
      //               int.parse(defaultMedicationsData.items[i].default_time1
      //                   .substring(0, 2))) *
      //           60 +
      //       (nowMin -
      //           int.parse(defaultMedicationsData.items[i].default_time1
      //               .substring(3)));
      //   if (timeDifference < 0) {
      //     timeDifference = timeDifference + 1440;
      //   }
      //   if (timeDifference < calculatedTimeDifference) {
      //     setState(() {
      //       calculatedTimeDifference = timeDifference;

      //       nameIndex = i;
      //     });
      //   }
      // }

    }
    setState(() {
      _isLoading = false;
      _isInit = false;
    });
  }

  String _name = "Loading ...";
  bool _nameChanged = false;
  bool pressed1 = true;
  bool pressed2 = false;
  List<String> medicationNames = [];
  List<DefaultMedicationItem> defaultMedicationsDataForButtons = [
    DefaultMedicationItem(
      id: "1",
      default_med_name: "Loading ...",
      amount: "1",
    ),
  ];

  List<bool> chosenButtonCheck = [
    false,
  ];

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
  bool pickTimeFlag = false;
  //String _chosenOptimalTime;

  String _takenTime = TimeOfDay.now().toString().substring(10, 15);
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

  String _numPills = "";
  //int _numOfTimes = 1;

  //final _form = GlobalKey<FormState>();

  var _newNormalMedication = NormalMedicationItem(
    id: Uuid().v1(),
    taken_med_name: null,
    taken_dateTime: null,
    taken_amount: "1",
  );
  //var _isLoading = false;

  Future<void> _saveForm(
      _name, _takenDateTime, _optimalTime, _takenTime, _numPills) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
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

    // if (_optimalTime == null) {
    //   setState(() {
    //     _timeValidator = false;
    //   });
    //   return;
    // }

    if (_takenTime == null) {
      setState(() {
        _timeValidator = false;
      });
      return;
    }

    var normalMedicationItem = NormalMedicationItem(
      id: _newNormalMedication.id,
      taken_med_name: _name,
      taken_dateTime: _takenDateTime,
      taken_amount: _numPills,
    );
    _newNormalMedication = normalMedicationItem;
    //_form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<NormalMedications>(context, listen: false)
          .addNormalMedication(_newNormalMedication);
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
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

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

  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Add Booster Medication'),
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

    if (_takenTime != null) {
      //_optimalTime != null &&
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
            : Container(
                child: _internet
                    ? RefreshIndicator(
                        onRefresh: () => _refreshAddNormalMedications(context),
                        child: Container(
                          height: height * 0.8,

                          child: ListView(
                            children: <Widget>[
                              Container(
                                height: height * 0.38,
                                //width: width,
                                padding: EdgeInsets.fromLTRB(width * 0.04,
                                    height * 0.01, width * 0.04, height * 0.01),
                                child: Container(
                                  color: Colors.grey[350],
                                  // decoration: BoxDecoration(
                                  //   color: const Color(0xff7c94b6),
                                  //   border: Border.all(
                                  //     color: Colors.black,
                                  //     width: 0,
                                  //   ),
                                  //   borderRadius: BorderRadius.circular(12),
                                  // ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: height * 0.04,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,

                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Medication name: ",
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
                                                "$_name",
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
                                        height: height * 0.32,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            MedicationNamesButtons(
                                              //medicationNames[0],
                                              defaultMedicationsDataForButtons,
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
                              Container(
                                height: height * 0.15,
                                //width: width,
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
                                child: Container(
                                  color: Colors.grey[350],
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: height * 0.04,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                                color: Colors.lightBlue[900],
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                      style: BorderStyle.solid),
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
                                                    fontWeight: FontWeight.bold,
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
                              if (_dateValidator == false)
                                Text(
                                  "Please input the missing date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              Container(
                                height: height * 0.15,
                                //width: width,
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
                                child: Container(
                                  color: Colors.grey[350],
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: height * 0.04,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Amount taken: ",
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
                                                "$_numPills",
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
                                        height: height * 0.09,
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              width: width * 0.9 - 20,
                                              height: height * 0.07,
                                              child: Form(
                                                key: _form,
                                                child: TextFormField(
                                                  //initialValue: "",
                                                  // decoration: InputDecoration(
                                                  //     labelText: 'amount'),
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  maxLength: 20,
                                                  //onFieldSubmitted: (_) {
                                                  //FocusScope.of(context).requestFocus(_priceFocusNode);
                                                  //},
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please provide a value.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _numPills = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
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
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
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
                            ],
                          ),
                          //),
                          //),
                        ),
                      )
                    : NoInternet(AddNormalMedicationScreen.routeName),
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
