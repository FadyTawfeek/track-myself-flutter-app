import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/games_class.dart';

class UserGameItem extends StatelessWidget {
  final String id;
  final DateTime dateTime;
  final String score;
  final String level;

  UserGameItem(
    this.id,
    this.dateTime,
    this.score,
    this.level,
  );

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    Color scoreColor;
    if (double.parse(score) > 90) {
      scoreColor = Colors.lightGreenAccent[700];
    } else if (double.parse(score) > 80) {
      scoreColor = Colors.deepOrangeAccent[400];
    } else {
      scoreColor = Colors.redAccent[700];
    }
    String levelString;
    if (level == "Easy (0.5 seconds)") {
      levelString = "Easy";
    } else if (level == "Medium (1.5 seconds)") {
      levelString = "Medium";
    } else {
      levelString = "Hard";
    }

    return ListTile(
      leading: FlutterLogo(size: 56.0),
      title: Text(
        "$score @ $levelString level",
        style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "\n${DateFormat("dd-MM-yyyy '@' HH:mm").format(dateTime).toString()}",
        style: TextStyle(fontWeight: FontWeight.bold),
        //overflow: TextOverflow.ellipsis,
      ),
      // Text(dateTime.toString()),
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
                          await Provider.of<Games>(context, listen: false)
                              .deleteGame(id);
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
