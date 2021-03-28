import 'dart:async';
import 'dart:core';
import 'dart:io';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/widgets/default_medications_buttons.dart';
//import 'package:stop1/widgets/medication_groups_names_buttons.dart';
//import 'package:stop1/widgets/medication_names_buttons.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:uuid/uuid.dart';
import '../providers/defaultMedication_class.dart';
//import '../widgets/app_drawer.dart';
//import 'addDefaultMedication_screen.dart';
//import 'package:intl/intl.dart';
// import 'package:uuid/uuid.dart';

// enum SymptomOptions {
//   No_symptoms,
//   Light_symptoms,
//   Mild_symptoms,
//   Strong_symptoms,
//   Severe_symptoms,
// }

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
  //String _selectedSymptom = "No symptoms";

  void updateName(String newName) {
    setState(() {
      defaultMedNames.add(newName);
      //print(defaultMedNames);
      _nameChanged = true;
    });
  }

  void updateName2(String newName) {
    setState(() {
      defaultMedNames.remove(newName);
      //print(defaultMedNames);
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
  //TimeOfDay.now().toString().substring(10, 15);

  bool duplicatedDefaultMedicationGroup = false;

  bool _timeValidator = true;
  bool _defaultMedicationsValidator = true;

  List<String> medicationNames = [];

  List<DefaultMedicationItem> defaultMedicationsDataForButtons = [
    DefaultMedicationItem(
        id: "1", default_med_name: "Loading ...", amount: "1"),
  ];

  //////////////////
  ///////////////////
  ///////////////////
  /////////////////
  /////////////////
  ////////////////
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
  int _numOfTimes = 1;
  bool pickTimeFlag = false;

  final _form = GlobalKey<FormState>();

  // var _newDefaultMedicationGroup = DefaultMedicationGroup(
  //   id: Uuid().v1(),
  //   default_group_name: null,
  //   default_time: null,
  //   listOfMedicationItems: null,
  // );
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

      //setState(() {});
      defaultMedicationsDataForButtons = defaultMedicationsData.items;
      //print(defaultMedicationsGroupsDataForButtons[0].default_group_name);

      //if (defaultMedicationsData.items.isNotEmpty) {
      for (var i = 0; i < defaultMedicationsData.items.length; i++) {
        medicationNames.add(defaultMedicationsData.items[i].default_med_name);
      }
      //}

      // await Provider.of<DefaultMedicationsGroups>(context, listen: false)
      //     .findByName(_name);

      //print("name is $_name");

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

    //print("name is $_name");

    //print("name issssss $_name");
    // await Provider.of<DefaultMedicationsGroups>(context, listen: false)
    //     .fetchDefaultMedicationsGroups();

    try {
      //print("name is: $_name");
      await Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .findByName(_name);
      final defaultMedicationsGroupsData =
          Provider.of<DefaultMedicationsGroups>(context, listen: false);

      // await Provider.of<DefaultMedications>(context, listen: false)
      //     .fetchDefaultMedications();

      // final defaultMedsData =
      //     Provider.of<DefaultMedications>(context, listen: false).items;

      if (defaultMedicationsGroupsData.items3.isNotEmpty) {
        setState(() {
          duplicatedDefaultMedicationGroup = true;
        });
        return;
      }
      // else
      //   setState(() {
      //     duplicatedDefaultMedicationGroup = false;
      //   });
      setState(() {
        _isLoading = true;
      });

      List<DefaultMedicationItem> theListOfMedicationItems =
          List<DefaultMedicationItem>();

      for (var i = 0; i < defaultMedicationNames.length; i++) {
        //print(defaultMedicationNames.length);

        await Provider.of<DefaultMedications>(context, listen: false)
            .findByName(defaultMedicationNames[i]);

        DefaultMedicationItem newDefaultMed =
            Provider.of<DefaultMedications>(context, listen: false).items3[0];
        //print("aaaa${newDefaultMed.default_med_name}");

        theListOfMedicationItems.add(newDefaultMed);
      }
      //print("object");
      //print(theListOfMedicationItems[0].default_med_name);

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
    // Navigator.of(context).pop();
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
      //key: _scaffoldKey,
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
                        onRefresh: () =>
                            _refreshAddDefaultMedicationGroup(context),
                        child: Container(
                          height: height,
                          //width: width,
//                        child: Container(
                          // child: Form(
                          //   key: _form,
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

                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.center,
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Medication group name: ",
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
                                                  //     labelText: 'Name'),
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  maxLength: 30,
                                                  onTap: () {
                                                    setState(() {
                                                      duplicatedDefaultMedicationGroup =
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

                              //Center(child: Text("Date taken")),
                              //Divider(),
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
                                              "Time: ",
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
                                                _time1 == null ? '' : "$_time1",
                                                //"$_time1",
                                                //"${DateFormat("dd-MM-yyyy '@' hh:mm").format(_takenDateTime)}",
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
                                            // Text(
                                            //   "Not now ? ",
                                            //   style: TextStyle(
                                            //     //color: Colors.lightBlue[900],
                                            //     fontSize: width * 0.04,
                                            //     fontStyle: FontStyle.italic,
                                            //   ),
                                            // ),
                                            RaisedButton(
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
                                                textColor: _time1 != null
                                                    ? Colors.amber[900]
                                                    : Colors.white,
                                                // child: FittedBox(
                                                //   fit: BoxFit.fitWidth,
                                                // child: Flexible(
                                                //   fit: FlexFit.loose,
                                                child: Text(
                                                  'Choose Time',
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
                              // Row(
                              //   children: [
                              //     Text("Chosen medication names: "),
                              //     Center(
                              //       child: Text(defaultMedNames.toString()),
                              //     ),
                              //   ],
                              // ),
                              Container(
                                height: height * 0.4,
                                //width: width,
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.01, width * 0.03, height * 0.01),
                                child: Container(
                                  color: Colors.grey[350],
                                  // child: Column(
                                  //   children: <Widget>[
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
                                          //medicationNames[0],
                                          defaultMedicationsDataForButtons,
                                          updateName,
                                          updateName2,
                                          //_asyncStuff2,
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
                              // Text(
                              //   "Please choose at least one default medication",
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.red),
                              // ),
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
                // Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Center(
                //         child: Text("No internet"),
                //       ),
                //       Center(
                //         child: IconButton(
                //           icon: const Icon(Icons.refresh),
                //           onPressed: () {
                //             Navigator.of(context).pushReplacementNamed(
                //                 AddDefaultMedicationGroupScreen.routeName);
                //           },
                //         ),
                //       )
                //     ],
                //   ),
              ),
      ),
      //  Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Form(
      //     key: _form,
      //     child: ListView(
      //       children: <Widget>[
      //         Center(child: Text("Medication name")),
      //         TextFormField(
      //           //initialValue: "",
      //           decoration: InputDecoration(labelText: 'Medication name'),
      //           textInputAction: TextInputAction.next,
      //           //initialValue: "initial name",
      //           //onFieldSubmitted: (_) {
      //           //FocusScope.of(context).requestFocus(_priceFocusNode);
      //           //},
      //           validator: (value) {
      //             if (value.isEmpty) {
      //               return 'Please provide a value.';
      //             }
      //             return null;
      //           },
      //           onChanged: (value) {
      //             setState(() {
      //               _name = value;
      //             });
      //           },
      //           // onSaved: (value) {
      //           //   _editedProduct = Product(
      //           //       title: value,
      //           //       price: _editedProduct.price,
      //           //       description: _editedProduct.description,
      //           //       imageUrl: _editedProduct.imageUrl,
      //           //       id: _editedProduct.id,
      //           //       isFavorite: _editedProduct.isFavorite);
      //           // },
      //         ),
      //         if (duplicatedDefaultMedicationGroup == true)
      //           Text(
      //             "A medication with given name already exists",
      //             style:
      //                 TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      //           ),
      //         // Center(child: Text("Number of times per day")),
      //         // Row(
      //         //   children: <Widget>[
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('1'),
      //         //           Radio(
      //         //             value: 1,
      //         //             groupValue: _numOfTimes,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numOfTimes = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('2'),
      //         //           Radio(
      //         //             value: 2,
      //         //             groupValue: _numOfTimes,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numOfTimes = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('3'),
      //         //           Radio(
      //         //             value: 3,
      //         //             groupValue: _numOfTimes,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numOfTimes = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('4'),
      //         //           Radio(
      //         //             value: 4,
      //         //             groupValue: _numOfTimes,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numOfTimes = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('5'),
      //         //           Radio(
      //         //             value: 5,
      //         //             groupValue: _numOfTimes,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numOfTimes = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //   ],
      //         // ),
      //         SingleChildScrollView(
      //           child: Container(
      //             //height: 180,
      //             width: double.infinity,
      //             child: Column(
      //               children: <Widget>[
      //                 if (_timeValidator == false)
      //                   Text(
      //                     "Please input the missing time(s)",
      //                     style: TextStyle(
      //                         fontWeight: FontWeight.bold, color: Colors.red),
      //                   ),
      //                 Padding(
      //                   padding: EdgeInsets.all(8),
      //                   // child: ListView.builder(
      //                   //   itemCount: _numOfTimes,
      //                   //   //_numOfTimes
      //                   //   itemBuilder: (_, i) =>
      //                   child: Column(
      //                     children: <Widget>[
      //                       Center(
      //                         child: Text("Time: "),
      //                       ),
      //                       Text(
      //                         _time1 == null
      //                             ? 'No Time Chosen!'
      //                             : "Picked Time: $_time1",
      //                       ),
      //                       FlatButton(
      //                         onPressed: _presentTimePicker1,
      //                         child: Text('Choose Time'),
      //                       ),
      //                       Divider(),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         Row(
      //           children: [
      //             Text("Chosen medication names: "),
      //             Center(
      //               child: Text(defaultMedNames.toString()),
      //             ),
      //           ],
      //         ),
      //         // Center(child: Text("Number of pills per time")),
      //         // Row(
      //         //   children: <Widget>[
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('1'),
      //         //           Radio(
      //         //             value: 1,
      //         //             groupValue: _numPills,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numPills = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('2'),
      //         //           Radio(
      //         //             value: 2,
      //         //             groupValue: _numPills,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numPills = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('3'),
      //         //           Radio(
      //         //             value: 3,
      //         //             groupValue: _numPills,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numPills = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('4'),
      //         //           Radio(
      //         //             value: 4,
      //         //             groupValue: _numPills,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numPills = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //     Expanded(
      //         //       child: Row(
      //         //         children: <Widget>[
      //         //           Text('5'),
      //         //           Radio(
      //         //             value: 5,
      //         //             groupValue: _numPills,
      //         //             onChanged: (value) {
      //         //               setState(() {
      //         //                 _numPills = value;
      //         //               });
      //         //             },
      //         //           )
      //         //         ],
      //         //       ),
      //         //     ),
      //         //   ],
      //         // ),
      //         if (_defaultMedicationsValidator == false)
      //           Text(
      //             "Please choose at least one default medication",
      //             style:
      //                 TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      //           ),
      //         Container(
      //           height: height * 0.08,
      //           child: Row(
      //             mainAxisSize: MainAxisSize.max,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               DefaultMedicationButtons(
      //                 //medicationNames[0],
      //                 defaultMedicationsDataForButtons,
      //                 updateName,
      //                 updateName2,
      //                 //_asyncStuff2,
      //                 chosenButtonCheck,
      //                 resetChosenButtonCheck,
      //               ),
      //             ],
      //           ),
      //         ),
      //         // InkWell(
      //         //   onTap: () => Navigator.of(context)
      //         //       .pushNamed(AddDefaultMedicationScreen.routeName),
      //         //   child: Card(
      //         //     shape: RoundedRectangleBorder(
      //         //       borderRadius: BorderRadius.circular(15),
      //         //     ),
      //         //     elevation: 4,
      //         //     margin: EdgeInsets.all(10),
      //         //     child: Column(
      //         //       children: <Widget>[
      //         //         Positioned(
      //         //           bottom: 20,
      //         //           right: 10,
      //         //           child: Container(
      //         //             width: 150,
      //         //             color: Colors.blue,
      //         //             padding: EdgeInsets.symmetric(
      //         //               vertical: 5,
      //         //               horizontal: 20,
      //         //             ),
      //         //             child: Text(
      //         //               'add default medication ?',
      //         //               textAlign: TextAlign.center,
      //         //               style: TextStyle(
      //         //                 fontSize: 26,
      //         //                 color: Colors.white,
      //         //               ),
      //         //               softWrap: true,
      //         //               overflow: TextOverflow.fade,
      //         //             ),
      //         //           ),
      //         //         )
      //         //       ],
      //         //     ),
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

// Form(
//   key: _form,
//   child: ListView(
//     children: <Widget>[
//       TextFormField(
//         decoration: InputDecoration(labelText: 'Enter text'),
//         textInputAction: TextInputAction.done,
//         onFieldSubmitted: (_) {
//           _saveForm();
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             return 'Please provide a value.';
//           }
//           return null;
//         },
// onSaved: (value) {
//   var symptomItem = SymptomItem(
//     dateTime: DateTime.now(),
//     symptom: value,
//     id: _newSymptom.id,
//   );
//   _newSymptom = symptomItem;
// },
//       ),
//     ],
//   ),
// ),
