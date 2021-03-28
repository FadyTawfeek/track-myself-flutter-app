import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stop1/screens/play_game_screen.dart';
import 'package:stop1/widgets/noInternet.dart';

import '../widgets/user_game_item.dart';
import '../screens/my_home_page.dart';
import '../providers/games_class.dart';
import '../widgets/app_drawer.dart';
import './addSymptom_screen.dart';

// ignore: must_be_immutable
class GamesScreen extends StatefulWidget {
  static const routeName = '/games';

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  var _isInit = true;
  var _isLoading = false;
  var _internet = false;

  Future<void> _refreshGames(BuildContext context) async {
    await Provider.of<Games>(context, listen: false).fetchGames();
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
      Provider.of<Games>(context, listen: false).fetchGames().then((_) {
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
      title: Text('Games Scores'),
      // actions: <Widget>[
      //   IconButton(
      //     icon: const Icon(Icons.add),
      //     onPressed: () {
      //       Navigator.of(context).pushNamed(PlayGameScreen.routeName);
      //     },
      //   ),
      // ],
    );
    final mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    double width = mediaQuery.size.width;
    final gamesData = Provider.of<Games>(context);
    final reversedList = gamesData.items.reversed.toList();
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
                        onRefresh: () => _refreshGames(context),
                        child: Container(
                          height: height,
                          width: width,
                          child: ListView.builder(
                            itemCount: reversedList.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserGameItem(
                                  reversedList[i].id,
                                  reversedList[i].dateTime,
                                  reversedList[i].score,
                                  reversedList[i].level,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      )
                    : NoInternet(GamesScreen.routeName),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(PlayGameScreen.routeName);
        },
        child: Icon(Icons.gamepad),
        backgroundColor: Colors.lightBlue[900],
      ),
    );
  }
}
