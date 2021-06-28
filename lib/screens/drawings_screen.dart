import 'package:flutter/material.dart';

class DrawingsScreen extends StatelessWidget {
  static const routeName = '/drawings';
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.lightBlue[900],
      title: Text('STOP'),
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
        child: Center(
          child: Text('Drawings body'),
        ),
      ),
    );
  }
}
