import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
import '../widgets/medication_names_buttons.dart';
import '../providers/normalMedication_class.dart';
import '../providers/defaultMedication_class.dart';
import 'package:intl/intl.dart';
import '../screens/addSymptom_screen.dart';
import '../screens/more_screen.dart';

class AddNormalMedicationScreen extends StatefulWidget {
  static const routeName = '/add-normal-medication';

  AddNormalMedicationScreen({Key key}) : super(key: key);

  @override
  _AddNormalMedicationScreenState createState() =>
      _AddNormalMedicationScreenState();
}

class _AddNormalMedicationScreenState extends State<AddNormalMedicationScreen> {
  final _form = GlobalKey<FormState>();

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

  Future<void> _asyncStuff2() async {}

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

      await Provider.of<NormalMedications>(context, listen: false)
          .fetchNormalMedications();

      defaultMedicationsDataForButtons = defaultMedicationsData.items;

      for (var i = 0; i < defaultMedicationsData.items.length; i++) {
        medicationNames.add(defaultMedicationsData.items[i].default_med_name);
      }

      int nameIndex = 0;

      setState(() {
        if (medicationNames.isNotEmpty) {
          _name = medicationNames[nameIndex];
        }
        chosenButtonCheck[nameIndex] = true;
      });
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

  List<String> medicationOptimalTimes = [];

  String _optimalTime = "Loading ...";
  bool pickTimeFlag = false;

  String _takenTime = TimeOfDay.now().toString().substring(10, 15);

  bool _timeValidator = true;
  bool _dateValidator = true;
  bool _nameValidator = true;

  DateTime _takenDateTime = DateTime.now();

  String _numPills = "";

  var _newNormalMedication = NormalMedicationItem(
    id: Uuid().v1(),
    taken_med_name: null,
    taken_dateTime: null,
    taken_amount: "1",
  );

  Future<void> _saveForm(
      _name, _takenDateTime, _optimalTime, _takenTime, _numPills) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

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
    setState(() {
      _isLoading = false;
    });
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
                                padding: EdgeInsets.fromLTRB(width * 0.04,
                                    height * 0.01, width * 0.04, height * 0.01),
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
                                          children: [
                                            Text(
                                              "Medication name: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[900],
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                                          children: [
                                            Text(
                                              "Date and time: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[900],
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
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                                child: Text(
                                                  'Choose different Date and time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                              if (_dateValidator == false)
                                Text(
                                  "Please input the missing date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              Container(
                                height: height * 0.15,
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
                                          children: [
                                            Text(
                                              "Amount taken: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[900],
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  maxLength: 20,
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
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
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
