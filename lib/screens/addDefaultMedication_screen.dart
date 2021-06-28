import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/defaultMedication_class.dart';

class AddDefaultMedicationScreen extends StatefulWidget {
  static const routeName = '/add-default-medication';
  AddDefaultMedicationScreen({Key key}) : super(key: key);

  @override
  _AddDefaultMedicationScreenState createState() =>
      _AddDefaultMedicationScreenState();
}

class _AddDefaultMedicationScreenState
    extends State<AddDefaultMedicationScreen> {
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

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

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
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                                            textInputAction:
                                                TextInputAction.next,
                                            maxLength: 30,
                                            onTap: () {
                                              setState(() {
                                                duplicatedDefaultMedication =
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
                                    children: [
                                      Text(
                                        "Amount: ",
                                        style: TextStyle(
                                          color: Colors.lightBlue[900],
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
