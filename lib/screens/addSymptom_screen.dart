import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:stop1/providers/defaultMedication_class.dart';
import 'package:uuid/uuid.dart';
//import '../screens/addNormalMedication_screen.dart';
import '../screens/more_screen.dart';
import '../providers/symptom_class.dart';
import '../widgets/app_drawer.dart';
import 'package:intl/intl.dart';

import 'addNormalMedicationGroup_screen.dart';
// import 'package:uuid/uuid.dart';

// enum SymptomOptions {
//   No_symptoms,
//   Light_symptoms,
//   Mild_symptoms,
//   Strong_symptoms,
//   Severe_symptoms,
// }

class AddSymptomScreen extends StatefulWidget {
  static const routeName = '/add-symptom';
  AddSymptomScreen({Key key}) : super(key: key);

  @override
  _AddSymptomScreenState createState() => _AddSymptomScreenState();
}

class _AddSymptomScreenState extends State<AddSymptomScreen> {
  String _selectedSymptom = "No symptoms";

  final _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // var _newSymptom = SymptomItem(
  //   id: null,
  //   dateTime: null,
  //   symptom: '',
  //   tag: '',
  // );
  var _isLoading = false;
  String _tag = '';
  DateTime _selectedDate = DateTime.now();
  bool pickTimeFlag = false;
  //bool saveDone = false;

  List<bool> chosenButtonCheck = [
    true,
    false,
    false,
    false,
    false,
  ];
  List<String> chosenButtonSymptoms = [
    "No symptoms",
    "Light symptoms",
    "Mild symptoms",
    "Strong symptoms",
    "Severe symptoms",
  ];

  void updateName(String newName) {
    setState(() {
      _selectedSymptom = newName;
      //_nameChanged = true;
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  Future<void> _saveForm(_selectedSymptom, _selectedDate, _tag) async {
    // final isValid = _form.currentState.validate();
    // if (!isValid) {
    //   return;
    // }
    var symptomItem = SymptomItem(
      id: Uuid().v1(),
      dateTime: _selectedDate,
      symptom: _selectedSymptom,
      //.toString(),
      tag: _tag,
    );
    //_newSymptom =
    //symptomItem;

    //_form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      //print("1");
      await Provider.of<Symptoms>(context, listen: false)
          .addSymptom(symptomItem);
      //final database = moor.$SymptomsTable;
      // print("a $database");
      //final database2 = moor.AppDatabase;

      //Provider.of<moor.AppDatabase>(context);
      //print("b $database2");
      // final newSymptom = moor.Symptom(
      //   basicId: 2,
      //   id: Uuid().v1(),
      //   takenDateTime: _selectedDate,
      //   symptom: _selectedSymptom.toString(),
      //   tag: _tag,
      // );
      // print("3");

      // print(moor.Symptoms);
      // print(moor.Symptom);
      // print(moor.SymptomsCompanion);

      //database2

      //.insertSymptom(newSymptom);
      // final a = await moor.AppDatabase.instance.insertSymptom(newSymptom);
      // print(moor.AppDatabase.instance);

      //database2.instance.insertSymptom(newSymptom);
      //print("4");
      //print(database2);
      //print("5");
      //resetValuesAfterSubmit();

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
    // setState(() {
    //   //_isLoading = false;
    //   saveDone = true;
    // });
    Navigator.of(context).pop(true);
    // print("object");
    // _scaffoldKey.currentState
    //     .showSnackBar(SnackBar(content: Text("Symptom was added")));
    // print("object2");

    // Navigator.of(context).pop();
  }

  Future<void> _presentDatePicker() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return null;
      }
      setState(() {
        _selectedDate = pickedDate;
        //.toString().substring(10, 15);
        //_time1 = time;
      });
    });
  }

  Future<void> _refreshAddSymptom(BuildContext context) async {
    await Provider.of<Symptoms>(context, listen: false).fetchSymptoms();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Add Symptom Survey'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      bottomNavigationBar: SymptomsBottomBar(height, width),
      //drawer: AppDrawer(),
      appBar: appBar,
      key: _scaffoldKey,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                // child: _internet
                //     ?
                child: RefreshIndicator(
                  onRefresh: () => _refreshAddSymptom(context),
                  child: Container(
                    height: height * 0.8,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: height * 0.38,
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
                                    children: <Widget>[
                                      Text(
                                        "Symptom: ",
                                        style: TextStyle(
                                          color: Colors.lightBlue[900],
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          "$_selectedSymptom",
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
                                          chosenButtonSymptoms[i],
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
                                                i < chosenButtonSymptoms.length;
                                                i++) {
                                              chosenButtonCheck.add(false);
                                            }
                                            //print(chosenButtonCheck);
                                            chosenButtonCheck[i] = true;
                                            //print(chosenButtonCheck);

                                            updateName(
                                              chosenButtonSymptoms[i],
                                            );
                                            resetChosenButtonCheck(
                                                chosenButtonCheck);
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
                                          "${DateFormat("dd-MM-yyyy").format(_selectedDate)}",
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Not today ? ",
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
                                            'Choose different Date',
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
                                              _presentDatePicker();
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // if (duplicatedDefaultMedication == true)
                        //   Text(
                        //     "A medication with given name already exists",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, color: Colors.red),
                        //   ),

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
                                        "Comment: ",
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
                                          _tag == null ? '' : "$_tag",
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
                                            //initialValue: "#",
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
                                                _tag = value;
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

                              onPressed: () => _saveForm(
                                  _selectedSymptom, _selectedDate, _tag),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),

      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Form(
      //     key: _form,
      //     child: ListView(
      //       children: <Widget>[
      //         // Padding(
      //         //   padding: EdgeInsets.all(8),
      //         //   // child: ListView.builder(
      //         //   //   itemCount: _numOfTimes,
      //         //   //   //_numOfTimes
      //         //   //   itemBuilder: (_, i) =>
      //         //   child: Column(
      //         //     children: <Widget>[
      //         //       Center(
      //         //         child: Text("Date: "),
      //         //       ),

      //         //       Text(
      //         //         _selectedDate == null
      //         //             ? 'No Date Chosen!'
      //         //             : "Picked Date: ${DateFormat("dd-MM-yyyy").format(_selectedDate)}",
      //         //         //"Picked Date and time: $_selectedDate",
      //         //       ),
      //         //       FlatButton(
      //         //         onPressed: _presentDatePicker,
      //         //         child: Text('Choose Date'),
      //         //       ),

      //         //       //_displaySnackBar(context),

      //         //       //Text('Please input the time!'),
      //         //       //  () {
      //         //       //   Scaffold.of(context).showSnackBar(
      //         //       //     SnackBar(
      //         //       //       content: Text(
      //         //       //         'Please input the time!',
      //         //       //       ),
      //         //       //       duration: Duration(seconds: 2),
      //         //       //       // action: SnackBarAction(
      //         //       //       //   label: 'UNDO',
      //         //       //       //   onPressed: () {
      //         //       //       //     cart.removeSingleItem(product.id);
      //         //       //       //   },
      //         //       //       // ),
      //         //       //     ),
      //         //       //   );
      //         //       // },

      //         //       // SnackBar(
      //         //       //   content: Text('Please input the time!'),
      //         //       // ),
      //         //       Divider(),
      //         //     ],
      //         //   ),
      //         // ),
      //         ListTile(
      //           title: const Text('There are no symptoms'),
      //           leading: Radio(
      //             value: "No symptoms",
      //             groupValue: _selectedSymptom,
      //             onChanged: (value) {
      //               setState(() {
      //                 _selectedSymptom = value;
      //               });
      //             },
      //           ),
      //         ),
      //         ListTile(
      //           title: const Text('There are light symptoms'),
      //           leading: Radio(
      //             value: "Light symptoms",
      //             groupValue: _selectedSymptom,
      //             onChanged: (value) {
      //               setState(() {
      //                 _selectedSymptom = value;
      //               });
      //             },
      //           ),
      //         ),
      //         ListTile(
      //           title: const Text('There are mild symptoms'),
      //           leading: Radio(
      //             value: "Mild symptoms",
      //             groupValue: _selectedSymptom,
      //             onChanged: (value) {
      //               setState(() {
      //                 _selectedSymptom = value;
      //               });
      //             },
      //           ),
      //         ),
      //         ListTile(
      //           title: const Text('There are strong symptoms'),
      //           leading: Radio(
      //             value: "Strong symptoms",
      //             groupValue: _selectedSymptom,
      //             onChanged: (value) {
      //               setState(() {
      //                 _selectedSymptom = value;
      //               });
      //             },
      //           ),
      //         ),
      //         ListTile(
      //           title: const Text('There are severe symptoms'),
      //           leading: Radio(
      //             value: "Severe symptoms",
      //             groupValue: _selectedSymptom,
      //             onChanged: (value) {
      //               setState(() {
      //                 _selectedSymptom = value;
      //               });
      //             },
      //           ),
      //         ),
      //         TextFormField(
      //           //initialValue: "",
      //           decoration: InputDecoration(labelText: 'Tag'),
      //           textInputAction: TextInputAction.next,
      //           initialValue: '#',
      //           onChanged: (value) {
      //             setState(() {
      //               _tag = value;
      //             });
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class SymptomsBottomBar extends StatelessWidget {
  final height;
  final width;
  SymptomsBottomBar(this.height, this.width);
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
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          AddNormalMedicationGroupScreen.routeName,
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.assignment_return,
                            color: Colors.white,
                          ),
                          Text(
                            "Medication",
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
                      onPressed: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.accessibility_new,
                            color: Colors.amber[900],
                          ),
                          Text(
                            "Daily Survey",
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
