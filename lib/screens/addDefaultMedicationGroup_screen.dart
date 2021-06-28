import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/widgets/default_medications_buttons.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
import '../providers/defaultMedication_class.dart';

class AddDefaultMedicationGroupScreen extends StatefulWidget {
  static const routeName = '/add-default-medication-group';
  AddDefaultMedicationGroupScreen({Key key}) : super(key: key);

  @override
  _AddDefaultMedicationGroupScreenState createState() =>
      _AddDefaultMedicationGroupScreenState();
}

class _AddDefaultMedicationGroupScreenState
    extends State<AddDefaultMedicationGroupScreen> {
  var _isInit = true;
  var _isLoading = true;
  var _internet = false;

  void updateName(String newName) {
    setState(() {
      defaultMedNames.add(newName);
      _nameChanged = true;
    });
  }

  void updateName2(String newName) {
    setState(() {
      defaultMedNames.remove(newName);
      _nameChanged = true;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  String _name;
  List<String> defaultMedNames = [];

  String _time1;

  bool duplicatedDefaultMedicationGroup = false;

  bool _timeValidator = true;
  bool _defaultMedicationsValidator = true;

  List<String> medicationNames = [];

  List<DefaultMedicationItem> defaultMedicationsDataForButtons = [
    DefaultMedicationItem(
        id: "1", default_med_name: "Loading ...", amount: "1"),
  ];

  int _numPills = 1;
  int _numOfTimes = 1;
  bool pickTimeFlag = false;

  final _form = GlobalKey<FormState>();

  Future<void> _refreshAddDefaultMedicationGroup(BuildContext context) async {
    await Provider.of<DefaultMedicationsGroups>(context, listen: false)
        .fetchDefaultMedicationsGroups();
  }

  @override
  void initState() {
    _asyncStuff();
    super.initState();
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

      defaultMedicationsDataForButtons = defaultMedicationsData.items;

      for (var i = 0; i < defaultMedicationsData.items.length; i++) {
        medicationNames.add(defaultMedicationsData.items[i].default_med_name);
      }
    }
    setState(() {
      _isLoading = false;
      _isInit = false;
    });
  }

  bool _nameChanged = false;
  List<bool> chosenButtonCheck = [false];

  Future<void> _saveForm(
      _name, _time1, _numOfTimes, _numPills, defaultMedicationNames) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    if (_numOfTimes == 1) {
      if (_time1 == null) {
        setState(() {
          _timeValidator = false;
        });
        return;
      }
    }
    if (defaultMedicationNames.isEmpty) {
      setState(() {
        _defaultMedicationsValidator = false;
      });
      return;
    }

    try {
      //print("name is: $_name");
      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .findByName(_name);
      final defaultMedicationsGroupsData =
          Provider.of<DefaultMedicationsGroups>(context, listen: false);

      if (defaultMedicationsGroupsData.items3.isNotEmpty) {
        setState(() {
          duplicatedDefaultMedicationGroup = true;
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      List<DefaultMedicationItem> theListOfMedicationItems =
          List<DefaultMedicationItem>();

      for (var i = 0; i < defaultMedicationNames.length; i++) {
        await Provider.of<DefaultMedications>(context, listen: false)
            .findByName(defaultMedicationNames[i]);

        DefaultMedicationItem newDefaultMed =
            Provider.of<DefaultMedications>(context, listen: false).items3[0];

        theListOfMedicationItems.add(newDefaultMed);
      }

      var defaultMedicationGroup = DefaultMedicationGroup(
        id: Uuid().v1(),
        default_group_name: _name,
        default_time: _time1,
        listOfMedicationItems: theListOfMedicationItems,
      );
      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .addDefaultMedicationGroup(defaultMedicationGroup);
    } catch (error) {
      //print("object");
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

  Future<void> _presentTimePicker1() async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return null;
      }
      setState(() {
        var time = pickedTime.toString().substring(10, 15);
        _time1 = time;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Add Default Medication group'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    if (_numOfTimes == 1) {
      if (_time1 != null) {
        setState(() {
          _timeValidator = true;
        });
      }
    }
    if (defaultMedNames.isNotEmpty) {
      setState(() {
        _defaultMedicationsValidator = true;
      });
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: _internet
                    ? RefreshIndicator(
                        onRefresh: () =>
                            _refreshAddDefaultMedicationGroup(context),
                        child: Container(
                          height: height,
                          child: ListView(
                            children: <Widget>[
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
                                          children: [
                                            Text(
                                              "Medication group name: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[900],
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                _name == null ? '' : "$_name",
                                                overflow: TextOverflow.ellipsis,
                                                //"$_name",
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
                                        height: height * 0.07,
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
                                                  maxLength: 30,
                                                  onTap: () {
                                                    setState(() {
                                                      duplicatedDefaultMedicationGroup =
                                                          false;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please provide a value.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _name = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, height * 0.01, 0, height * 0.01),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (duplicatedDefaultMedicationGroup == true)
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03 + 10,
                                      height * 0.003,
                                      width * 0.03 + 10,
                                      height * 0.005),
                                  child: Text(
                                    "A medication with given name already exists",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
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
                                          children: [
                                            Text(
                                              "Time: ",
                                              style: TextStyle(
                                                color: Colors.lightBlue[900],
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Text(
                                                _time1 == null ? '' : "$_time1",
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
                                            RaisedButton(
                                                elevation: 15,
                                                color: Colors.lightBlue[900],
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 2,
                                                      style: BorderStyle.solid),
                                                ),
                                                textColor: _time1 != null
                                                    ? Colors.amber[900]
                                                    : Colors.white,
                                                child: Text(
                                                  'Choose Time',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pickTimeFlag = true;
                                                    _presentTimePicker1();
                                                  });
                                                }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_timeValidator == false)
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03 + 10,
                                      height * 0.003,
                                      width * 0.03 + 10,
                                      height * 0.005),
                                  child: Text(
                                    "Please input the missing time",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                              Container(
                                height: height * 0.4,
                                //width: width,
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
                                child: Container(
                                  color: Colors.grey[350],
                                  child: Container(
                                    height: height * 0.38,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DefaultMedicationButtons(
                                          defaultMedicationsDataForButtons,
                                          updateName,
                                          updateName2,
                                          chosenButtonCheck,
                                          resetChosenButtonCheck,
                                        ),
                                      ],
                                    ),
                                  ),
                                  //   ],
                                  // ),
                                ),
                              ),
                              if (_defaultMedicationsValidator == false)
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03 + 10,
                                      height * 0.003,
                                      width * 0.03 + 10,
                                      height * 0.005),
                                  child: Text(
                                    "Please choose at least one default medication",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
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
                                        _time1,
                                        _numOfTimes,
                                        _numPills,
                                        defaultMedNames),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //),
                          //),
                        ),
                      )
                    : NoInternet(AddDefaultMedicationGroupScreen.routeName),
              ),
      ),
    );
  }
}
