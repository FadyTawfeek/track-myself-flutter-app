//import 'dart:io';

//import 'dart:html';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/defaultMedication_class.dart';
import '../screens/addNormalMedication_screen.dart';

typedef StringCallback = void Function(String name);
typedef StringCallback2 = void Function(String name);
typedef CallbackChosenButtonCheck = void Function(List chosenButtonCheck);

// ignore: must_be_immutable
class DefaultMedicationButtons extends StatefulWidget {
  final List<DefaultMedicationItem> defaultMedicationsData;
  final StringCallback updateName;
  final StringCallback2 updateName2;
  List<bool> chosenButtonCheck;
  final CallbackChosenButtonCheck resetChosenButtonCheck;

  DefaultMedicationButtons(this.defaultMedicationsData, this.updateName,
      this.updateName2, this.chosenButtonCheck, this.resetChosenButtonCheck);

  //get defaultMedicationsDataForButtons => defaultMedicationsDataForButtons;

  @override
  _DefaultMedicationButtonsState createState() =>
      _DefaultMedicationButtonsState();
}

class _DefaultMedicationButtonsState extends State<DefaultMedicationButtons> {
  bool pressed1 = false;

  //[true, false];

  // List<bool> chosenButtonCheck = [
  //   true,
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

  //new List<bool>.filled(10, false);
  //chosenButtonCheck[0]=true;

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      title: Text('default medication buttons'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    //widget.chosenButtonCheck[widget.nameIndex] = true;

    return Container(
      // height: height/8.5,
      // width: width,
      //height: 50,
      height: height * 0.38,
      width: width * 0.9,
      child: GridView.builder(
        //scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: width / (height / 3),
        ),
        itemCount: widget.defaultMedicationsData.length,
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
              height * 0.01,
              width * 0.01,
              //75 / widget.defaultMedicationsData.length,
              height * 0.01),
          child: RaisedButton(
            //padding: EdgeInsets.all(5),
            elevation: 15,
            //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.lightBlue[900],
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
            ),
            textColor:
                widget.chosenButtonCheck[i] ? Colors.amber[900] : Colors.white,
            // child: FittedBox(
            //   fit: BoxFit.fitWidth,
            // child: Flexible(
            //   fit: FlexFit.loose,
            child: Text(
              widget.defaultMedicationsData[i].default_med_name,
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
                // widget.chosenButtonCheck = [
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

                if (widget.chosenButtonCheck[i] == true) {
                  widget.chosenButtonCheck[i] = false;
                  widget.updateName2(
                    widget.defaultMedicationsData[i].default_med_name,
                  );
                } else {
                  widget.chosenButtonCheck[i] = true;
                  //print(widget.defaultMedicationsData[i].default_med_name);
                  widget.updateName(
                    widget.defaultMedicationsData[i].default_med_name,
                  );
                }

                // if (widget.chosenButtonCheck[i] == false) {

                // }
                widget.resetChosenButtonCheck(widget.chosenButtonCheck);
                //widget.asyncStuff2();
              });
            },
          ),
        ),
      ),
      // ),
    );
    // Platform.isIOS
    //     ? CupertinoButton(
    //         child: Text(
    //           widget.text,
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         onPressed: widget.handler,
    //       )
    //     :
  }
}
