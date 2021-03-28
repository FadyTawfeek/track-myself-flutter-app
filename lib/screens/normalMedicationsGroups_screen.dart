import 'package:flutter/material.dart';
import 'package:stop1/providers/normalMedicationGroups_class.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:stop1/widgets/user_normal_medication_group.dart';
import '../widgets/app_drawer.dart';

import 'dart:io';

import 'package:provider/provider.dart';

import '../widgets/user_normal_medication_item.dart';
import '../providers/normalMedication_class.dart';
import 'addNormalMedicationGroup_screen.dart';
import 'addNormalMedication_screen.dart';

class NormalMedicationsGroupsScreen extends StatefulWidget {
  static const routeName = '/normal-medications-groups';

  @override
  _NormalMedicationsGroupsScreenState createState() =>
      _NormalMedicationsGroupsScreenState();
}

class _NormalMedicationsGroupsScreenState
    extends State<NormalMedicationsGroupsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshNormalMedicationsGroups(BuildContext context) async {
    await Provider.of<NormalMedicationsGroups>(context, listen: false)
        .fetchNormalMedicationsGroups();
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
      Provider.of<NormalMedicationsGroups>(context, listen: false)
          .fetchNormalMedicationsGroups()
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
      title: Text('Medication groups'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.of(context)
      //           .pushNamed(AddNormalMedicationGroupScreen.routeName);
      //     },
      //   ),
      // ],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    final normalMedicationsGroupsData =
        Provider.of<NormalMedicationsGroups>(context);
    final reversedList = normalMedicationsGroupsData.items.reversed.toList();
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
                        onRefresh: () =>
                            _refreshNormalMedicationsGroups(context),
                        child: Container(
                          height: height,
                          width: width,
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserNormalMedicationGroup(
                                  reversedList[i].id,
                                  reversedList[i].normal_group_name,
                                  reversedList[i].optimal_time,
                                  reversedList[i].taken_dateTime,
                                  reversedList[i].listOfMedicationItems,
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
                    : NoInternet(NormalMedicationsGroupsScreen.routeName),
                // Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Center(
                //         child: Text("No internet"),
                //       ),
                //       Center(
                //         child: IconButton(
                //           icon: const Icon(Icons.refresh),
                //           onPressed: () {
                //             Navigator.of(context).pushNamed(
                //                 NormalMedicationsGroupsScreen.routeName);
                //           },
                //         ),
                //       )
                //     ],
                //   ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
                .pushNamed(AddNormalMedicationGroupScreen.routeName);
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
