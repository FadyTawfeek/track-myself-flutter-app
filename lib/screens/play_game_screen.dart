import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../providers/games_class.dart';
//import '../widgets/app_drawer.dart';

class PlayGameScreen extends StatefulWidget {
  static const routeName = '/play-game';
  PlayGameScreen({Key key}) : super(key: key);

  //final String title;

  @override
  _PlayGameScreenState createState() => _PlayGameScreenState();
}

class _PlayGameScreenState extends State<PlayGameScreen> {
  @override
  void initState() {
    _readDifficulty();
    super.initState();
  }

  String chosenDifficulty;
  int timerCount;
  int maxTimerCount = 2999;
  String difficultyText;
  var _isLoading = false;
  bool isInit = true;
  bool gameFailedFlag = false;

  // List<bool> chosenButtonCheck = [
  //   true,
  //   false,
  //   false,
  // ];
  // List<String> chosenButtonDifficulties = [
  //   "Easy (1 second)",
  //   "Medium (2 seconds)",
  //   "Hard (3 seconds)",
  // ];

  // void updateDifficulty(String newName) {
  //   setState(() {
  //     chosenDifficulty = newName;
  //     //_nameChanged = true;
  //   });
  // }

  // void resetChosenButtonCheck(List newList) {
  //   setState(() {
  //     chosenButtonCheck = newList;
  //   });
  // }

  _readDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();
    final key = 'my_diff_key';
    final value = difficultyPreference.getString(key) ?? "Easy (0.5 seconds)";
    //print('read: $value');
    setState(() {
      chosenDifficulty = value;
      if (chosenDifficulty == "Easy (0.5 seconds)") {
        timerCount = 49;
        difficultyText = "0.5 seconds";
      }
      if (chosenDifficulty == "Medium (1.5 seconds)") {
        timerCount = 149;
        difficultyText = "1.5 seconds";
      }
      if (chosenDifficulty == "Hard (3 seconds)") {
        timerCount = 299;
        difficultyText = "3 seconds";
      }
      //print(chosenDifficulty);
    });
  }

  Future<void> _saveForm(score) async {
    // final isValid = _form.currentState.validate();
    // if (!isValid) {
    //   return;
    // }
    var gameItem = GameItem(
      id: Uuid().v1(),
      dateTime: DateTime.now(),
      score: score,
      level: chosenDifficulty,
      //.toString(),
    );
    //_newSymptom =
    //symptomItem;

    //_form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      //print("1");
      await Provider.of<Games>(context, listen: false).addGame(gameItem);
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
    Navigator.of(context).pop();
    // print("object");
    // _scaffoldKey.currentState
    //     .showSnackBar(SnackBar(content: Text("Symptom was added")));
    // print("object2");

    // Navigator.of(context).pop();
  }

  //String toBe;

  // color of the circle
  Color color = Colors.greenAccent;

  // event returned from accelerometer stream
  AccelerometerEvent event;

  // hold a refernce to these, so that they can be disposed
  Timer timer;
  StreamSubscription accel;

  // positions and count
  double top = 125;
  double right;
  int count = 1;
  int counter = 0;

  // variables for screen size
  double width;
  double height;
  double height2;
  double totalAccelerometer = 0;
  double score = 0;
  double finalScore = -1;

  setColor(AccelerometerEvent event) {
    // Calculate Left
    double x = ((event.x * 12) + ((width - 100) / 2));
    // Calculate Top
    double y = event.y * 12 + 125;

    // find the difference from the target position
    var xDiff = x.abs() - ((width - 100) / 2);
    var yDiff = y.abs() - 125;

    // check if the circle is centered, currently allowing a buffer of 3 to make centering easier
    if (xDiff.abs() < 3 && yDiff.abs() < 3) {
      // set the color and increment count
      setState(() {
        color = Colors.greenAccent;
        count += 1;
      });
    } else {
      // set the color and restart count
      setState(() {
        color = Colors.red;
        count = 0;
      });
    }
  }

  setPosition(AccelerometerEvent event) {
    if (event == null) {
      return;
    }

    // When x = 0 it should be centered horizontally
    // The right positin should equal (width - 100) / 2
    // The greatest absolute value of x is 10, multipling it by 12 allows the right position to move a total of 120 in either direction.
    setState(() {
      right = ((event.x * 12) + ((width - 100) / 2));
    });

    // When y = 0 it should have a top position matching the target, which we set at 125
    setState(() {
      top = event.y * 12 + 125;
    });
  }

  startTimer() {
    setState(() {
      isInit = false;
      gameFailedFlag = false;
    });
    // if the accelerometer subscription hasn't been created, go ahead and create it
    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      // it has already been created so just resume it
      accel.resume();
    }

    // Accelerometer events come faster than we need them so a timer is used to only proccess them every 200 milliseconds
    if (timer == null || !timer.isActive) {
      totalAccelerometer = 0;
      score = 0;
      counter = 0;
      finalScore = -1;
      timer = Timer.periodic(Duration(milliseconds: 10), (_) {
        setState(() {
          //print(totalAccelerometer);
          //print(counter);
          counter += 1;
          totalAccelerometer +=
              ((event?.x?.abs() ?? 0) + (event?.y?.abs() ?? 0) / 2);
        });
        // if (totalAccelerometer > 250000) {
        //   Navigator.of(context).pop();
        // }
        // if count has increased greater than time needed, call pause timer to handle success
        if (count > timerCount) {
          pauseTimer();
        } else if (counter > maxTimerCount) {
          //print(counter);
          stopTimer();
        } else {
          // proccess the current event
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    // stop the timer and pause the accelerometer stream
    timer.cancel();
    accel.pause();
    setState(() {
      score = totalAccelerometer / counter;
      finalScore = 100 - (score * 10);
    });

    // set the success color and reset the count
    setState(() {
      count = 1;
      color = Colors.green;
    });
  }

  stopTimer() {
    // stop the timer and pause the accelerometer stream
    //print("object");
    timer.cancel();
    accel.pause();
    setState(() {
      //score = totalAccelerometer / counter;
      finalScore = 0;
      //100 - (score * 10);
    });

    setState(() {
      count = 1;
      gameFailedFlag = true;
      //color = Colors.red;
    });
  }

  calculateScore() {}

  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // get the width and height of the screen
    // width = MediaQuery.of(context).size.width;
    // height = MediaQuery.of(context).size.height;
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Play game'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    height2 = height - 350;
    width = mediaQuery.size.width;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Container(
                    //height: height * 0.6,
                    child: Column(
                      children: [
                        Container(
                          height: height2 * 0.22,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.05, height2 * 0.01, width * 0.05, 0),
                          //fromLTRB(10, 10, 10, 10),
                          child: Container(
                            height: height2 * 0.21,
                            child:
                                // FittedBox(
                                //   fit: BoxFit.fitWidth,
                                //   // child: FittedBox(
                                //   //   fit: BoxFit.cover,
                                //   child:
                                FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                (isInit)
                                    ? "Keep the ball in the center of the small green circle\nfor $difficultyText in less than 30 seconds!\n(Tip: Start while holding the phone horizontally)."
                                    : "",
                                style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  //fontSize: 14,
                                  //width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  //fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            //),
                          ),
                        ),
                        //go to settings to change the game level.\n(Tip: start while holding the phone horizontally)
                        //),
                        Stack(
                          children: [
                            // This empty container is given a width and height to set the size of the stack
                            Container(
                              //height: height / 2,
                              height: 350,
                              width: width,
                            ),

                            // Create the outer target circle wrapped in a Position
                            Positioned(
                              // positioned 50 from the top of the stack
                              // and centered horizontally, right = (ScreenWidth - Container width) / 2
                              top: 50,
                              right: (width - 250) / 2,
                              child: Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.red, width: 2.0),
                                  borderRadius: BorderRadius.circular(125),
                                ),
                              ),
                            ),
                            // This is the colored circle that will be moved by the accelerometer
                            // the top and right are variables that will be set
                            Positioned(
                              top: top,
                              right: right ?? (width - 100) / 2,
                              // the container has a color and is wrappeed in a ClipOval to make it round
                              child: ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: color,
                                ),
                              ),
                            ),
                            // inner target circle wrapped in a Position
                            Positioned(
                              top: 125,
                              right: (width - 100) / 2,
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Text('x: ${(event?.x ?? 0).toStringAsFixed(3)}'),
                        // Text('y: ${(event?.y ?? 0).toStringAsFixed(3)}'),
                        if (isInit)
                          Container(
                            //width: width,
                            height: height2 * 0.25,
                            padding: EdgeInsets.fromLTRB(width * 0.03,
                                height2 * 0.01, width * 0.03, height2 * 0.01),
                            child: Container(
                              // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                // child: FittedBox(
                                //   fit: BoxFit.fitWidth,
                                child: Text(
                                  '     Start     ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.06,
                                  ),
                                ),
                                //),
                                //),
                                //),
                                onPressed: startTimer,
                                // onPressed: () => _saveForm(
                                //     _selectedSymptom,
                                //     _selectedDate,
                                //     _tag),
                              ),
                            ),
                          ),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       horizontal: 16.0, vertical: 8.0),
                        //   child: RaisedButton(
                        //     onPressed: startTimer,
                        //     child: Text('Start'),
                        //     color: Theme.of(context).primaryColor,
                        //     textColor: Colors.white,
                        //   ),
                        // ),
                        // Text("total accelerometer is: $totalAccelerometer"),
                        // Text("score is: $score"),
                        // Text("final score is: $finalScore"),
                        // Text("$chosenDifficulty"),
                        if (finalScore != -1)
                          Container(
                            height: height2 * 0.7,
                            child: Column(
                              children: [
                                Container(
                                  height: height2 * 0.225,
                                  padding: EdgeInsets.fromLTRB(width * 0.03, 0,
                                      width * 0.03, height2 * 0.01),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Center(
                                      child: Text(
                                        (gameFailedFlag == true)
                                            ? "Time is up!"
                                            : (finalScore > 90)
                                                ? "Excellent!"
                                                : (finalScore > 80)
                                                    ? "You can do better!"
                                                    : "Not your best game!",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: (gameFailedFlag == true)
                                                ? Colors.redAccent[700]
                                                : (finalScore > 90)
                                                    ? Colors
                                                        .lightGreenAccent[700]
                                                    : (finalScore > 80)
                                                        ? Colors
                                                            .deepOrangeAccent[400]
                                                        : Colors.redAccent[700],
                                            //fontSize: width * 0.1,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height2 * 0.225,
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03,
                                      height2 * 0.005,
                                      width * 0.03,
                                      height2 * 0.02),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.center,
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: height2 * 0.2,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Score: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[900],
                                              //fontSize: width * 0.1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //),
                                      // FittedBox(
                                      //   fit: BoxFit.fitWidth,
                                      //child:
                                      // Flexible(
                                      //   fit: FlexFit.loose,
                                      //child:
                                      Container(
                                        height: height2 * 0.2,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "${finalScore.toStringAsFixed(1)}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: (gameFailedFlag == true)
                                                    ? Colors.redAccent[700]
                                                    : (finalScore > 90)
                                                        ? Colors.lightGreenAccent[
                                                            700]
                                                        : (finalScore > 80)
                                                            ? Colors.deepOrangeAccent[
                                                                400]
                                                            : Colors
                                                                .redAccent[700],
                                                //fontSize: width * 0.1,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      //),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: height2 * 0.25,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        //width: width,
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.03,
                                            height2 * 0.01,
                                            width * 0.03,
                                            height2 * 0.01),
                                        child: Container(
                                          // padding:
                                          //     EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                              '    Submit    ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.06,
                                              ),
                                            ),
                                            //),
                                            //),
                                            onPressed: () => _saveForm(
                                                finalScore.toStringAsFixed(1)),
                                            // onPressed: () => _saveForm(
                                            //     _selectedSymptom,
                                            //     _selectedDate,
                                            //     _tag),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        //width: width,
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.03,
                                            height2 * 0.01,
                                            width * 0.03,
                                            height2 * 0.01),
                                        child: Container(
                                          // padding:
                                          //     EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                              '  Try again  ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.06,
                                              ),
                                            ),
                                            onPressed: startTimer,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// class PlayGameScreen extends StatelessWidget {
//   static const routeName = '/play-game';
//   @override
//   Widget build(BuildContext context) {
//     final PreferredSizeWidget appBar = AppBar(
//       backgroundColor: Colors.lightBlue[900],
//       title: Text('STOP-play game'),
//       actions: <Widget>[],
//     );
//     final mediaQuery = MediaQuery.of(context);
//     double height = mediaQuery.size.height -
//         mediaQuery.padding.top -
//         appBar.preferredSize.height;
//     double width = mediaQuery.size.width;
//     final gamesData = Provider.of<Games>(context);
//     return Scaffold(
//       appBar: appBar,
//       //drawer: AppDrawer(),
//       body: SafeArea(
//         child: ListView.builder(
//           itemCount: gamesData.itemCount,
//           itemBuilder: (ctx, i) => GameItem(gamesData.items[i]),
//         ),
//       ),
//     );
//   }
// }
