//import 'dart:io';

//import 'dart:html';

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import '../providers/defaultMedication_class.dart';
import '../screens/addNormalMedication_screen.dart';

typedef StringCallback = void Function(String name);
typedef CallbackHandle = void Function();
typedef CallbackChosenButtonCheck = void Function(List chosenButtonCheck);

// ignore: must_be_immutable
class MedicationGroupsNamesButtons extends StatefulWidget {
  final List<DefaultMedicationGroup> defaultMedicationsGroupsData;
  final StringCallback updateName;
  final CallbackHandle asyncStuff2;
  List<bool> chosenButtonCheck;
  final CallbackChosenButtonCheck resetChosenButtonCheck;

  MedicationGroupsNamesButtons(
      this.defaultMedicationsGroupsData,
      this.updateName,
      this.asyncStuff2,
      this.chosenButtonCheck,
      this.resetChosenButtonCheck);

  //get defaultMedicationsDataForButtons => defaultMedicationsDataForButtons;

  @override
  _MedicationGroupsNamesButtonsState createState() =>
      _MedicationGroupsNamesButtonsState();
}

class _MedicationGroupsNamesButtonsState
    extends State<MedicationGroupsNamesButtons> {
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
      title: Text('medication groups names buttons'),
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
      height: height * 0.32,
      width: width * 0.9,
      child: GridView.builder(
        //shrinkWrap: true,
        //scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: width / (height / 3),
        ),

        itemCount: widget.defaultMedicationsGroupsData.length,
        // Row(
        //   //crossAxisAlignment: CrossAxisAlignment.max,
        //   //mainAxisSize: MainAxisSize.max,
        //   mainAxisSize: MainAxisSize.max,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: <Widget>[
        itemBuilder: (_, i) => Container(
          // width: width * 0.9 / widget.defaultMedicationsGroupsData.length,
          // height: height * 0.15,
          padding: EdgeInsets.fromLTRB(
              width * 0.01,
              //75 / widget.defaultMedicationsGroupsData.length,
              height * 0.01,
              width * 0.01,
              //75 / widget.defaultMedicationsGroupsData.length,
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
              widget.defaultMedicationsGroupsData[i].default_group_name,
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
                widget.chosenButtonCheck = [];
                //chosenButtonCheck = [];

                for (var i = 0;
                    i < widget.defaultMedicationsGroupsData.length;
                    i++) {
                  widget.chosenButtonCheck.add(false);
                }
                //print(chosenButtonCheck);
                widget.chosenButtonCheck[i] = true;
                //print(chosenButtonCheck);

                widget.updateName(
                  widget.defaultMedicationsGroupsData[i].default_group_name,
                );
                widget.resetChosenButtonCheck(widget.chosenButtonCheck);
                widget.asyncStuff2();
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
