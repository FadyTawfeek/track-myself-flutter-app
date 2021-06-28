import 'package:flutter/material.dart';
import 'package:stop1/screens/addDefaultMedication_screen.dart';
import '../screens/my_home_page.dart';
import '../screens/games_screen.dart';
import '../screens/normalMedications_screen.dart';
import '../screens/symptoms_screen.dart';
import '../screens/more_screen.dart';
import '../screens/dashboard_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('STOP'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context).pushNamed(MyHomePage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Game'),
            onTap: () {
              Navigator.of(context).pushNamed(GamesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Medication'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(NormalMedicationsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Symptoms'),
            onTap: () {
              Navigator.of(context).pushNamed(SymptomsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Drawings'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AddDefaultMedicationScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushNamed(DashboardScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).pushNamed(MoreScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
