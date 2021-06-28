import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../providers/games_class.dart';

class PlayGameScreen extends StatefulWidget {
  static const routeName = '/play-game';
  PlayGameScreen({Key key}) : super(key: key);

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

  _readDifficulty() async {
    final difficultyPreference = await SharedPreferences.getInstance();
    final key = 'my_diff_key';
    final value = difficultyPreference.getString(key) ?? "Easy (0.5 seconds)";

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
    });
  }

  Future<void> _saveForm(score) async {
    var gameItem = GameItem(
      id: Uuid().v1(),
      dateTime: DateTime.now(),
      score: score,
      level: chosenDifficulty,
    );

    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Games>(context, listen: false).addGame(gameItem);
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

    Navigator.of(context).pop();
  }

  Color color = Colors.greenAccent;

  AccelerometerEvent event;

  Timer timer;
  StreamSubscription accel;

  double top = 125;
  double right;
  int count = 1;
  int counter = 0;

  double width;
  double height;
  double height2;
  double totalAccelerometer = 0;
  double score = 0;
  double finalScore = -1;

  setColor(AccelerometerEvent event) {
    double x = ((event.x * 12) + ((width - 100) / 2));

    double y = event.y * 12 + 125;

    var xDiff = x.abs() - ((width - 100) / 2);
    var yDiff = y.abs() - 125;

    if (xDiff.abs() < 3 && yDiff.abs() < 3) {
      setState(() {
        color = Colors.greenAccent;
        count += 1;
      });
    } else {
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

    setState(() {
      right = ((event.x * 12) + ((width - 100) / 2));
    });

    setState(() {
      top = event.y * 12 + 125;
    });
  }

  startTimer() {
    setState(() {
      isInit = false;
      gameFailedFlag = false;
    });

    if (accel == null) {
      accel = accelerometerEvents.listen((AccelerometerEvent eve) {
        setState(() {
          event = eve;
        });
      });
    } else {
      accel.resume();
    }

    if (timer == null || !timer.isActive) {
      totalAccelerometer = 0;
      score = 0;
      counter = 0;
      finalScore = -1;
      timer = Timer.periodic(Duration(milliseconds: 10), (_) {
        setState(() {
          counter += 1;
          totalAccelerometer +=
              ((event?.x?.abs() ?? 0) + (event?.y?.abs() ?? 0) / 2);
        });

        if (count > timerCount) {
          pauseTimer();
        } else if (counter > maxTimerCount) {
          stopTimer();
        } else {
          setColor(event);
          setPosition(event);
        }
      });
    }
  }

  pauseTimer() {
    timer.cancel();
    accel.pause();
    setState(() {
      score = totalAccelerometer / counter;
      finalScore = 100 - (score * 10);
    });

    setState(() {
      count = 1;
      color = Colors.green;
    });
  }

  stopTimer() {
    timer.cancel();
    accel.pause();
    setState(() {
      finalScore = 0;
    });

    setState(() {
      count = 1;
      gameFailedFlag = true;
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
                    child: Column(
                      children: [
                        Container(
                          height: height2 * 0.22,
                          padding: EdgeInsets.fromLTRB(
                              width * 0.05, height2 * 0.01, width * 0.05, 0),
                          child: Container(
                            height: height2 * 0.21,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                (isInit)
                                    ? "Keep the ball in the center of the small green circle\nfor $difficultyText in less than 30 seconds!\n(Tip: Start while holding the phone horizontally)."
                                    : "",
                                style: TextStyle(
                                  color: Colors.lightBlue[900],
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 350,
                              width: width,
                            ),
                            Positioned(
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
                            Positioned(
                              top: top,
                              right: right ?? (width - 100) / 2,
                              child: ClipOval(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: color,
                                ),
                              ),
                            ),
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
                        if (isInit)
                          Container(
                            height: height2 * 0.25,
                            padding: EdgeInsets.fromLTRB(width * 0.03,
                                height2 * 0.01, width * 0.03, height2 * 0.01),
                            child: Container(
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
                                  '     Start     ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.06,
                                  ),
                                ),
                                onPressed: startTimer,
                              ),
                            ),
                          ),
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
                                    children: [
                                      Container(
                                        height: height2 * 0.2,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "Score: ",
                                            style: TextStyle(
                                              color: Colors.lightBlue[900],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
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
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.03,
                                            height2 * 0.01,
                                            width * 0.03,
                                            height2 * 0.01),
                                        child: Container(
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
                                              '    Submit    ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: width * 0.06,
                                              ),
                                            ),
                                            onPressed: () => _saveForm(
                                                finalScore.toStringAsFixed(1)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            width * 0.03,
                                            height2 * 0.01,
                                            width * 0.03,
                                            height2 * 0.01),
                                        child: Container(
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
