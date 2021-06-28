import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';

typedef StringCallback = void Function(String name);
typedef CallbackHandle = void Function();
typedef CallbackChosenButtonCheck = void Function(List chosenButtonCheck);

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

  @override
  _MedicationGroupsNamesButtonsState createState() =>
      _MedicationGroupsNamesButtonsState();
}

class _MedicationGroupsNamesButtonsState
    extends State<MedicationGroupsNamesButtons> {
  bool pressed1 = false;

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

    return Container(
      height: height * 0.32,
      width: width * 0.9,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: width / (height / 3),
        ),
        itemCount: widget.defaultMedicationsGroupsData.length,
        itemBuilder: (_, i) => Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.01, height * 0.01, width * 0.01, height * 0.01),
          child: RaisedButton(
            elevation: 15,
            color: Colors.lightBlue[900],
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.black, width: 2, style: BorderStyle.solid),
            ),
            textColor:
                widget.chosenButtonCheck[i] ? Colors.amber[900] : Colors.white,
            child: Text(
              widget.defaultMedicationsGroupsData[i].default_group_name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                widget.chosenButtonCheck = [];

                for (var i = 0;
                    i < widget.defaultMedicationsGroupsData.length;
                    i++) {
                  widget.chosenButtonCheck.add(false);
                }

                widget.chosenButtonCheck[i] = true;

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
    );
  }
}
