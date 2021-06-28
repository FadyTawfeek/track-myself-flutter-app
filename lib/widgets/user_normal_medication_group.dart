import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedication_class.dart';
import 'package:stop1/providers/normalMedicationGroups_class.dart';

class UserNormalMedicationGroup extends StatelessWidget {
  final String id;
  final String normal_group_name;
  final String optimal_time;
  final DateTime taken_dateTime;
  final List<DefaultMedicationItem> listOfMedicationItems;

  UserNormalMedicationGroup(
    this.id,
    this.normal_group_name,
    this.optimal_time,
    this.taken_dateTime,
    this.listOfMedicationItems,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(
        normal_group_name,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.lightBlue[900]),
      ),
      subtitle: Text(
        "\n${DateFormat("dd-MM-yyyy '@' HH:mm").format(taken_dateTime).toString()}",
        style: TextStyle(fontWeight: FontWeight.bold),
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
                          await Provider.of<NormalMedicationsGroups>(context,
                                  listen: false)
                              .deleteNormalMedicationGroup(id);
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
