import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/normalMedication_class.dart';

class UserNormalMedicationItem extends StatelessWidget {
  final String id;
  final String taken_med_name;
  final DateTime taken_dateTime;
  final String taken_amount;

  UserNormalMedicationItem(
    this.id,
    this.taken_med_name,
    this.taken_dateTime,
    this.taken_amount,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(
        taken_med_name,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.lightBlue[900]),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\n${DateFormat("dd-MM-yyyy '@' HH:mm").format(taken_dateTime).toString()}",
            style: TextStyle(fontWeight: FontWeight.bold),
            //overflow: TextOverflow.ellipsis,
          ),
          Text(
            "\n$taken_amount",
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.orange[900],
            ),
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
                          await Provider.of<NormalMedications>(context,
                                  listen: false)
                              .deleteNormalMedication(id);
                          scaffold.hideCurrentSnackBar();
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
                          scaffold.hideCurrentSnackBar();
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
            }

            //color: Theme.of(context).errorColor,
            ),
      ),
    );
  }
}
