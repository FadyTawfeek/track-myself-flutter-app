import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../screens/more_screen.dart';
import '../providers/symptom_class.dart';
import 'package:intl/intl.dart';
import 'addNormalMedicationGroup_screen.dart';

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

  var _isLoading = false;
  String _tag = '';
  DateTime _selectedDate = DateTime.now();
  bool pickTimeFlag = false;

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
    });
  }

  void resetChosenButtonCheck(List newList) {
    setState(() {
      chosenButtonCheck = newList;
    });
  }

  Future<void> _saveForm(_selectedSymptom, _selectedDate, _tag) async {
    var symptomItem = SymptomItem(
      id: Uuid().v1(),
      dateTime: _selectedDate,
      symptom: _selectedSymptom,
      tag: _tag,
    );

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Symptoms>(context, listen: false)
          .addSymptom(symptomItem);
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

    Navigator.of(context).pop(true);
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
      appBar: appBar,
      key: _scaffoldKey,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                                    itemCount: chosenButtonCheck.length,
                                    itemBuilder: (_, i) => Container(
                                      padding: EdgeInsets.fromLTRB(
                                          width * 0.01,
                                          height * 0.002,
                                          width * 0.01,
                                          height * 0.002),
                                      child: RaisedButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        elevation: 15,
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
                                        child: Text(
                                          chosenButtonSymptoms[i],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            chosenButtonCheck = [];

                                            for (var i = 0;
                                                i < chosenButtonSymptoms.length;
                                                i++) {
                                              chosenButtonCheck.add(false);
                                            }

                                            chosenButtonCheck[i] = true;

                                            updateName(
                                              chosenButtonSymptoms[i],
                                            );
                                            resetChosenButtonCheck(
                                                chosenButtonCheck);
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
                                          "${DateFormat("dd-MM-yyyy").format(_selectedDate)}",
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        "Not today ? ",
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
                                            'Choose different Date',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () {
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
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        "Comment: ",
                                        style: TextStyle(
                                          color: Colors.lightBlue[900],
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          _tag == null ? '' : "$_tag",
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
