import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/widgets/noInternet.dart';
import '../widgets/user_symptom_item.dart';
import '../providers/symptom_class.dart';
import './addSymptom_screen.dart';

class SymptomsScreen extends StatefulWidget {
  static const routeName = '/symptoms';

  @override
  _SymptomsScreenState createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshSymptoms(BuildContext context) async {
    await Provider.of<Symptoms>(context, listen: false).fetchSymptoms();
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
      Provider.of<Symptoms>(context, listen: false).fetchSymptoms().then((_) {
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
      title: Text('Symptoms surveys'),
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    final symptomsData = Provider.of<Symptoms>(context);
    final reversedList = symptomsData.items.reversed.toList();
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
                        onRefresh: () => _refreshSymptoms(context),
                        child: Container(
                          height: height,
                          width: width,
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserSymptomItem(
                                  reversedList[i].id,
                                  reversedList[i].dateTime,
                                  reversedList[i].symptom,
                                  reversedList[i].tag,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : NoInternet(SymptomsScreen.routeName),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddSymptomScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlue[900],
      ),
    );
  }
}
