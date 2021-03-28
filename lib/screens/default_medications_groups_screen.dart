import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:stop1/widgets/user_default_medication_group.dart';

import '../widgets/user_default_medication_item.dart';
import '../providers/defaultMedication_class.dart';
import '../widgets/app_drawer.dart';
import 'addDefaultMedicationGroup_screen.dart';
import 'addDefaultMedication_screen.dart';

// ignore: must_be_immutable
class DefaultMedicationsGroupsScreen extends StatefulWidget {
  static const routeName = '/default-medications-groups';

  @override
  _DefaultMedicationsGroupsScreenState createState() =>
      _DefaultMedicationsGroupsScreenState();
}

class _DefaultMedicationsGroupsScreenState
    extends State<DefaultMedicationsGroupsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshDefaultMedicationsGroups(BuildContext context) async {
    await Provider.of<DefaultMedicationsGroups>(context, listen: false)
        .fetchDefaultMedicationsGroups();
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
      Provider.of<DefaultMedicationsGroups>(context, listen: false)
          .fetchDefaultMedicationsGroups()
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
      title: Text('Default Medication groups'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.of(context)
      //           .pushNamed(AddDefaultMedicationGroupScreen.routeName);
      //     },
      //   ),
      // ],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    // ignore: non_constant_identifier_names
    final defaultMedicationsGroupsData =
        Provider.of<DefaultMedicationsGroups>(context);
    final reversedList = defaultMedicationsGroupsData.items.reversed.toList();
    //print(DefaultMedicationsData.items.length);
    //print(DefaultMedicationsData.items.length);
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
                            _refreshDefaultMedicationsGroups(context),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserDefaultMedicationGroup(
                                    reversedList[i].id,
                                    reversedList[i].default_group_name,
                                    reversedList[i].default_time,
                                    reversedList[i].listOfMedicationItems),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : NoInternet(DefaultMedicationsGroupsScreen.routeName),
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
                //             Navigator.of(context).pushReplacementNamed(
                //                 DefaultMedicationsGroupsScreen.routeName);
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
                .pushNamed(AddDefaultMedicationGroupScreen.routeName);
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
