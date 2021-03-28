import 'package:flutter/material.dart';
import 'package:stop1/widgets/noInternet.dart';
import '../widgets/app_drawer.dart';

import 'dart:io';

import 'package:provider/provider.dart';

import '../widgets/user_normal_medication_item.dart';
import '../providers/normalMedication_class.dart';
import './addNormalMedication_screen.dart';

class NormalMedicationsScreen extends StatefulWidget {
  static const routeName = '/normal-medications';

  @override
  _NormalMedicationsScreenState createState() =>
      _NormalMedicationsScreenState();
}

class _NormalMedicationsScreenState extends State<NormalMedicationsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshNormalMedications(BuildContext context) async {
    await Provider.of<NormalMedications>(context, listen: false)
        .fetchNormalMedications();
  }

  @override
  void initState() {
    _asyncStuff();
    super.initState();
  }

  Future<void> _asyncStuff() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty) {
        setState(() {
          _internet = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _internet = false;
      });
    }
    if (_isInit && _internet) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<NormalMedications>(context, listen: false)
          .fetchNormalMedications()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Booster Medications'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.of(context)
      //           .pushNamed(AddNormalMedicationScreen.routeName);
      //     },
      //   ),
      // ],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    final normalMedicationsData = Provider.of<NormalMedications>(context);
    final reversedList = normalMedicationsData.items.reversed.toList();
    //print(NormalMedicationsData.items.length);
    return Scaffold(
      appBar: appBar,
      //drawer: AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: _internet
                    ? RefreshIndicator(
                        onRefresh: () => _refreshNormalMedications(context),
                        child: Container(
                          height: height,
                          width: width,
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserNormalMedicationItem(
                                  reversedList[i].id,
                                  reversedList[i].taken_med_name,
                                  reversedList[i].taken_dateTime,
                                  reversedList[i].taken_amount,
                                ),
                                Divider(),
                                // Text("aa"),
                                // Text("data"),
                                // Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : NoInternet(NormalMedicationsScreen.routeName),
                
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
                .pushNamed(AddNormalMedicationScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue[900],
      ),
    );
  }
}

// showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: Text('An error occurred!'),
//           content: Text('Something went wrong.'),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Okay'),
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               },
//             )
//           ],
//         ),
//       );
