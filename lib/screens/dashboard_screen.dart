import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    _asyncStuff();
    super.initState();
  }

  var _isLoading = true;
  String theDeviceId;

  Future<void> _asyncStuff() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        var iosDeviceInfo = await deviceInfo.iosInfo;
        setState(() {
          theDeviceId = iosDeviceInfo.identifierForVendor;
        });
      } else {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        setState(() {
          theDeviceId = androidDeviceInfo.androidId;
        });
      }
    } on SocketException catch (_) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('Dashboard'),
      actions: <Widget>[],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                height: height,
                width: width,
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Text(
                      "Welcome to the dashboard where you can track your previous game scores, user symptom surveys, and medication adherence.\n\n\nSteps:\n\n1- Copy this 'Device ID'\n",
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          color: Colors.grey[350],
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '$theDeviceId',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        CopyButton(theDeviceId),
                      ],
                    ),
                    Text(
                      "\n2- Open this link, open the side bar menu (in the top left corner), and paste the Device ID you copied in the 'Device ID' field\n",
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkWell(
                      child: new Text(
                        'Link',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () => launch(
                        'https://fadytawfeek.shinyapps.io/Track-Myself/',
                      ),
                    ),
                    Text(
                      "\n(Tip: Rotate your phone to landscape mode, and zoom in for a better view)",
                      style: TextStyle(
                        color: Colors.lightBlue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class CopyButton extends StatefulWidget {
  final theDeviceId;
  CopyButton(this.theDeviceId);
  @override
  _CopyButtonState createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return RaisedButton(
      elevation: 15,
      color: Colors.lightBlue[900],
      shape: RoundedRectangleBorder(
        side:
            BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
      ),
      textColor: Colors.white,
      onPressed: () {
        Clipboard.setData(
          new ClipboardData(text: "${widget.theDeviceId}"),
        );
        try {
          scaffold.hideCurrentSnackBar();
          scaffold.showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                'Device ID copied!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } catch (error) {
          scaffold.hideCurrentSnackBar();
          scaffold.showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                'Failed to copy Device ID!',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      child: Text("Copy"),
    );
  }
}
