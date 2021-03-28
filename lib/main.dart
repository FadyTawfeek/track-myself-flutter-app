import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stop1/screens/addDefaultMedication_screen.dart';
import 'package:stop1/screens/default_medications_groups_screen.dart';
import 'package:stop1/screens/normalMedicationsGroups_screen.dart';
import 'package:stop1/screens/play_game_screen.dart';
import './providers/defaultMedicationGroups_class.dart';
import './providers/normalMedicationGroups_class.dart';
import './providers/normalMedication_class.dart';
import 'screens/addDefaultMedicationGroup_screen.dart';
import './screens/addNormalMedication_screen.dart';
import './providers/symptom_class.dart';
import './providers/defaultMedication_class.dart';
import './providers/games_class.dart';
import './screens/user_survey_screen.dart';
import './screens/games_screen.dart';
import './screens/normalMedications_screen.dart';
import './screens/symptoms_screen.dart';
import './screens/drawings_screen.dart';
import 'screens/more_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/my_home_page.dart';
import './screens/addSymptom_screen.dart';
import 'screens/settings_screen.dart';
import './screens/default_medications_screen.dart';
//import 'screens/addDefaultMedicationGroup_screen.dart';
import 'screens/addNormalMedicationGroup_screen.dart';
//import 'data/moor_database.dart' as moor;

// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as statusCodes;
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Games(),
        ),
        ChangeNotifierProvider.value(
          value: Symptoms(),
        ),
        ChangeNotifierProvider.value(
          value: DefaultMedications(),
        ),
        ChangeNotifierProvider.value(
          value: NormalMedications(),
        ),
        ChangeNotifierProvider.value(
          value: DefaultMedicationsGroups(),
        ),
        ChangeNotifierProvider.value(
          value: NormalMedicationsGroups(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //appBar: AppBar(),
        title: 'Track Myself',
        home: MyHomePage(),
        routes: {
          UserSurveyScreen.routeName: (ctx) => UserSurveyScreen(),
          GamesScreen.routeName: (ctx) => GamesScreen(),
          SymptomsScreen.routeName: (ctx) => SymptomsScreen(),
          DrawingsScreen.routeName: (ctx) => DrawingsScreen(),
          MoreScreen.routeName: (ctx) => MoreScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          AddSymptomScreen.routeName: (ctx) => AddSymptomScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          DefaultMedicationsScreen.routeName: (ctx) =>
              DefaultMedicationsScreen(),
          DefaultMedicationsGroupsScreen.routeName: (ctx) =>
              DefaultMedicationsGroupsScreen(),
          NormalMedicationsScreen.routeName: (ctx) => NormalMedicationsScreen(),
          NormalMedicationsGroupsScreen.routeName: (ctx) =>
              NormalMedicationsGroupsScreen(),
          AddDefaultMedicationScreen.routeName: (ctx) =>
              AddDefaultMedicationScreen(),
          AddDefaultMedicationGroupScreen.routeName: (ctx) =>
              AddDefaultMedicationGroupScreen(),
          AddNormalMedicationScreen.routeName: (ctx) =>
              AddNormalMedicationScreen(),
          AddNormalMedicationGroupScreen.routeName: (ctx) =>
              AddNormalMedicationGroupScreen(),
          PlayGameScreen.routeName: (ctx) => PlayGameScreen(),
        },
      ),
    );
  }
}

// Provider(
//       // The single instance of AppDatabase
//       //AppDatabase(),
//       create: (BuildContext context) {
//         AppDatabase();
//       },
//       child: MaterialApp(
//         title: 'Material App',
//         home: MyHomePage(),
//       ),
//     );
