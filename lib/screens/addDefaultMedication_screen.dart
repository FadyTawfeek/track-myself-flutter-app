import 'dart:async';
import 'dart:core';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/defaultMedication_class.dart';
//import '../widgets/app_drawer.dart';
//import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// enum SymptomOptions {
//   No_symptoms,
//   Light_symptoms,
//   Mild_symptoms,
//   Strong_symptoms,
//   Severe_symptoms,
// }

class AddDefaultMedicationScreen extends StatefulWidget {
  static const routeName = '/add-default-medication';
  AddDefaultMedicationScreen({Key key}) : super(key: key);

  @override
  _AddDefaultMedicationScreenState createState() =>
      _AddDefaultMedicationScreenState();
}

class _AddDefaultMedicationScreenState
    extends State<AddDefaultMedicationScreen> {
  //String _selectedSymptom = "No symptoms";

  String _name;

  String _time1;
  String _time2;
  String _time3;
  String _time4;
  String _time5;

  var _internet = false;

  bool duplicatedDefaultMedication = false;

  bool _timeValidator = true;

  Future<void> _refreshAddDefaultMedication(BuildContext context) async {
    await Provider.of<DefaultMedications>(context, listen: false)
        .fetchDefaultMedications();
  }
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
  int _numOfTimes = 1;

  final _form = GlobalKey<FormState>();
  final _form2 = GlobalKey<FormState>();

  var _newDefaultMedication = DefaultMedicationItem(
    id: Uuid().v1(),
    default_med_name: null,
    amount: "1",
  );
  var _isLoading = false;

  Future<void> _saveForm(_name, _numPills) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    final isValid2 = _form2.currentState.validate();
    if (!isValid2) {
      return;
    }

    try {
      //print("name is: $_name");
      await Provider.of<DefaultMedications>(context, listen: false)
          .findByName(_name);
      final defaultMedicationsData =
          Provider.of<DefaultMedications>(context, listen: false);

      if (defaultMedicationsData.items3.isNotEmpty) {
        setState(() {
          duplicatedDefaultMedication = true;
        });
        return;
      }
      // else
      //   setState(() {
      //     duplicatedDefaultMedication = false;
      //   });
      setState(() {
        _isLoading = true;
      });

      var defaultMedicationItem = DefaultMedicationItem(
        id: _newDefaultMedication.id,
        default_med_name: _name,
        amount: _numPills,
      );
      _newDefaultMedication = defaultMedicationItem;

      await Provider.of<DefaultMedications>(context, listen: false)
          .addDefaultMedication(_newDefaultMedication);
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

    //print("name is $_name");

    //print("name issssss $_name");
    // await Provider.of<DefaultMedications>(context, listen: false)
    //     .fetchDefaultMedications();

    //_form.currentState.save();

    // try {
    //   await Provider.of<DefaultMedications>(context, listen: false)
    //       .addDefaultMedication(_newDefaultMedication);
    // } catch (error) {
    //   await showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: Text('An error occurred!'),
    //       content: Text('Something went wrong.'),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('Okay'),
    //           onPressed: () {
    //             Navigator.of(ctx).pop();
    //           },
    //         )
    //       ],
    //     ),
    //   );
    // }
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

  // Future<void> _presentTimePicker1() async {
  //   await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return null;
  //     }
  //     setState(() {
  //       var time = pickedTime.toString().substring(10, 15);
  //       _time1 = time;
  //     });
  //   });
  // }

  // Future<void> _presentTimePicker2() async {
  //   await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return null;
  //     }
  //     setState(() {
  //       var time = pickedTime.toString().substring(10, 15);
  //       _time2 = time;
  //     });
  //   });
  // }

  // Future<void> _presentTimePicker3() async {
  //   await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return null;
  //     }
  //     setState(() {
  //       var time = pickedTime.toString().substring(10, 15);
  //       _time3 = time;
  //     });
  //   });
  // }

  // Future<void> _presentTimePicker4() async {
  //   await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return null;
  //     }
  //     setState(() {
  //       var time = pickedTime.toString().substring(10, 15);
  //       _time4 = time;
  //     });
  //   });
  // }

  // Future<void> _presentTimePicker5() async {
  //   await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((pickedTime) {
  //     if (pickedTime == null) {
  //       return null;
  //     }
  //     setState(() {
  //       var time = pickedTime.toString().substring(10, 15);
  //       _time5 = time;
  //     });
  //   });
  // }

  // _displaySnackBar(BuildContext context) {
  //   final snackBar = SnackBar(
  //     content: Text('Please input the time'),
  //     duration: Duration(seconds: 2),
  //   );
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  //   //edited line
  // }

  //final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Add Default Medication'),
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

    return Scaffold(
      //key: _scaffoldKey,
      //drawer: AppDrawer(),
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                // child: _internet
                //     ?
                child: RefreshIndicator(
                  onRefresh: () => _refreshAddDefaultMedication(context),
                  child: Container(
                    height: height * 0.8,
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                          _name == null ? '' : "$_name",
                                          overflow: TextOverflow.ellipsis,
                                          //"$_name",
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
                                  height: height * 0.07,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                            //     labelText: 'Name'),
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 30,
                                            onTap: () {
                                              setState(() {
                                                duplicatedDefaultMedication =
                                                    false;
                                              });
                                            },
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
                        if (duplicatedDefaultMedication == true)
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,

                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.center,
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Amount: ",
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
                                          _numPills == null ? '' : "$_numPills",
                                          overflow: TextOverflow.ellipsis,
                                          //"$_name",
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
                                  height: height * 0.07,
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        width: width * 0.9 - 20,
                                        height: height * 0.07,
                                        child: Form(
                                          key: _form2,
                                          child: TextFormField(
                                            //initialValue: "",
                                            // decoration: InputDecoration(
                                            //     labelText: 'Name'),
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      0, height * 0.01, 0, height * 0.01),
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

                              onPressed: () => _saveForm(_name, _numPills),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      //   ),
      // ),
    );
  }
}
