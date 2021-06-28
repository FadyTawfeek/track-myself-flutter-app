import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class GameItem {
  final String id;
  final DateTime dateTime;
  final String score;
  final String level;

  GameItem({
    @required this.id,
    @required this.dateTime,
    @required this.score,
    @required this.level,
  });
}

class Games with ChangeNotifier {
  List<GameItem> _items = [];

  List<GameItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  GameItem findById(String id) {
    return _items.firstWhere((gameItem) => gameItem.id == id);
  }

  Future<void> fetchGames() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/games.json';
    //const url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<GameItem> loadedGames = [];
      extractedData.forEach((gameId, gameData) {
        loadedGames.add(GameItem(
          id: gameData['id'],
          dateTime: DateTime.parse(gameData['dateTime']),
          score: gameData['score'],
          level: gameData['level'],
        ));
      });
      _items = loadedGames;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addGame(GameItem gameItem) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    //print(theDeviceId);
    final url = '$baseUrl/$theDeviceId/games.json';
    //final url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    final now = gameItem.dateTime;
    final timestamp = now.toIso8601String();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': gameItem.id,
          'dateTime': timestamp,
          'score': gameItem.score,
          'level': gameItem.level,
        }),
      );
      final newGameItem = GameItem(
          id: gameItem.id,
          //json.decode(response.body)['name'],
          dateTime: gameItem.dateTime,
          score: gameItem.score,
          level: gameItem.level);
      _items.add(newGameItem);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteGame(String id) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    //print(theDeviceId);
    final url = '$baseUrl/$theDeviceId/games.json';

    //const url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((gameId, gameData) {
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);

        if (gameData['id'] == id) {
          toBeDeletedItemId = gameId;
        }
      });
      //_items = loadedDefaultMedications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }

    final deleteUrl = '$baseUrl/$theDeviceId/games/$toBeDeletedItemId.json';
    final existingGameIndex = _items.indexWhere((game) => game.id == id);
    var existingGame = _items[existingGameIndex];
    _items.removeAt(existingGameIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(existingGameIndex, existingGame);
      notifyListeners();
      throw HttpException('Could not delete game.');
    }
    existingGame = null;
  }
}
