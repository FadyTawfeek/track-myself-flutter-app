import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/defaultMedication_class.dart';

class UserDefaultMedicationItem extends StatelessWidget {
  final String id;
  final String default_med_name;
  final String amount;

  UserDefaultMedicationItem(
    this.id,
    this.default_med_name,
    this.amount,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(
        default_med_name,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.lightBlue[900]),
      ),
      subtitle: Text(
        "\n$amount",
        //overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.orange[900],
        ),
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
                          await Provider.of<DefaultMedications>(context,
                                  listen: false)
                              .deleteDefaultMedication(id);
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
            }

            //color: Theme.of(context).errorColor,
            ),
      ),
    );
  }
}
