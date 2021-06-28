import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../providers/defaultMedication_class.dart';

typedef StringCallback = void Function(String name);
typedef StringCallback2 = void Function(String name);
typedef CallbackChosenButtonCheck = void Function(List chosenButtonCheck);

class DefaultMedicationButtons extends StatefulWidget {
  final List<DefaultMedicationItem> defaultMedicationsData;
  final StringCallback updateName;
  final StringCallback2 updateName2;
  List<bool> chosenButtonCheck;
  final CallbackChosenButtonCheck resetChosenButtonCheck;

  DefaultMedicationButtons(this.defaultMedicationsData, this.updateName,
      this.updateName2, this.chosenButtonCheck, this.resetChosenButtonCheck);

  @override
  _DefaultMedicationButtonsState createState() =>
      _DefaultMedicationButtonsState();
}

class _DefaultMedicationButtonsState extends State<DefaultMedicationButtons> {
  bool pressed1 = false;

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

    return Container(
      height: height * 0.38,
      width: width * 0.9,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: width / (height / 3),
        ),
        itemCount: widget.defaultMedicationsData.length,
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
              widget.defaultMedicationsData[i].default_med_name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                if (widget.chosenButtonCheck[i] == true) {
                  widget.chosenButtonCheck[i] = false;
                  widget.updateName2(
                    widget.defaultMedicationsData[i].default_med_name,
                  );
                } else {
                  widget.chosenButtonCheck[i] = true;

                  widget.updateName(
                    widget.defaultMedicationsData[i].default_med_name,
                  );
                }

                widget.resetChosenButtonCheck(widget.chosenButtonCheck);
              });
            },
          ),
        ),
      ),
    );
  }
}
