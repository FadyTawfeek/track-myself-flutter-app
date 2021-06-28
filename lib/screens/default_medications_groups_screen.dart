import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/providers/defaultMedicationGroups_class.dart';
import 'package:stop1/widgets/noInternet.dart';
import 'package:stop1/widgets/user_default_medication_group.dart';
import 'addDefaultMedicationGroup_screen.dart';

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
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    final defaultMedicationsGroupsData =
        Provider.of<DefaultMedicationsGroups>(context);
    final reversedList = defaultMedicationsGroupsData.items.reversed.toList();

    return Scaffold(
      appBar: appBar,
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
