import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/symptom_class.dart';

class UserSymptomItem extends StatelessWidget {
  final String id;
  final DateTime dateTime;
  final String symptom;
  final String tag;

  UserSymptomItem(
    this.id,
    this.dateTime,
    this.symptom,
    this.tag,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    Color symptomColor;
    if (symptom == "No symptoms") {
      symptomColor = Colors.lightGreenAccent[700];
    } else if (symptom == "Light symptoms") {
      symptomColor = Colors.lightBlue[900];
    } else if (symptom == "Mild symptoms") {
      symptomColor = Colors.amber;
    } else if (symptom == "Strong symptoms") {
      symptomColor = Colors.deepOrangeAccent[400];
    } else {
      symptomColor = Colors.redAccent[700];
    }
    return ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(
        symptom,
        style: TextStyle(fontWeight: FontWeight.bold, color: symptomColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\n${DateFormat("dd-MM-yyyy").format(dateTime).toString()}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (tag != "")
            Text(
              "\n$tag",
            ),
        ],
      ),
      trailing: Container(
        width: 50,
        child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Are you sure you want to delete this ?"),
                  actions: <Widget>[
                    RaisedButton(
                      elevation: 15,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("NO"),
                    ),
                    RaisedButton(
                      elevation: 15,
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        try {
                          await Provider.of<Symptoms>(context, listen: false)
                              .deleteSymptom(id);
                          Scaffold.of(context).hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                'Record deleted!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } catch (error) {
                          Scaffold.of(context).hideCurrentSnackBar();
                          scaffold.showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                'Deleting failed!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text("YES"),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
