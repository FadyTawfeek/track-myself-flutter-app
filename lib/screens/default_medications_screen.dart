import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/widgets/noInternet.dart';
import '../widgets/user_default_medication_item.dart';
import '../providers/defaultMedication_class.dart';
import 'addDefaultMedication_screen.dart';

class DefaultMedicationsScreen extends StatefulWidget {
  static const routeName = '/default-medications';

  @override
  _DefaultMedicationsScreenState createState() =>
      _DefaultMedicationsScreenState();
}

class _DefaultMedicationsScreenState extends State<DefaultMedicationsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshDefaultMedications(BuildContext context) async {
    await Provider.of<DefaultMedications>(context, listen: false)
        .fetchDefaultMedications();
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
      Provider.of<DefaultMedications>(context, listen: false)
          .fetchDefaultMedications()
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
      title: Text('Default Medications'),
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    final defaultMedicationsData = Provider.of<DefaultMedications>(context);
    final reversedList = defaultMedicationsData.items.reversed.toList();

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
                        onRefresh: () => _refreshDefaultMedications(context),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserDefaultMedicationItem(
                                  reversedList[i].id,
                                  reversedList[i].default_med_name,
                                  reversedList[i].amount,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : NoInternet(DefaultMedicationsScreen.routeName),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddDefaultMedicationScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue[900],
      ),
    );
  }
}
