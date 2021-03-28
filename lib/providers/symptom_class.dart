import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info/device_info.dart';

import '../models/baseUrl.dart' as baseUrlImport;
final baseUrl = baseUrlImport.baseUrl;

class SymptomItem {
  final String id;
  final DateTime dateTime;
  final String symptom;
  final String tag;

  SymptomItem(
      {@required this.id,
      @required this.dateTime,
      @required this.symptom,
      this.tag});
}

class Symptoms with ChangeNotifier {
  List<SymptomItem> _items = [];

  List<SymptomItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  SymptomItem findById(String id) {
    return _items.firstWhere((symptomItem) => symptomItem.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchSymptoms() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/symptoms.json';
    //const url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<SymptomItem> loadedSymptoms = [];
      extractedData.forEach((sympId, sympData) {
        loadedSymptoms.add(SymptomItem(
          id: sympData['id'],
          dateTime: DateTime.parse(sympData['dateTime']),
          symptom: sympData['symptom'],
          tag: sympData['tag'],
        ));
      });
      _items = loadedSymptoms;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addSymptom(SymptomItem symptomItem) async {
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
    final url = '$baseUrl/$theDeviceId/symptoms.json';
    //final url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    final now = symptomItem.dateTime;
    final timestamp = now.toIso8601String();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': symptomItem.id,
          'dateTime': timestamp,
          'symptom': symptomItem.symptom,
          'tag': symptomItem.tag
        }),
      );
      final newSymptomItem = SymptomItem(
        id: symptomItem.id,
        //json.decode(response.body)['name'],
        dateTime: symptomItem.dateTime,
        symptom: symptomItem.symptom,
        tag: symptomItem.tag,
      );
      _items.add(newSymptomItem);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteSymptom(String id) async {
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
    final url = '$baseUrl/$theDeviceId/symptoms.json';

    //const url = 'https://stop1-8af28.firebaseio.com/symptoms.json';
    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((sympId, sympData) {
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);

        if (sympData['id'] == id) {
          toBeDeletedItemId = sympId;
        }
      });
      //_items = loadedDefaultMedications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }

    final deleteUrl =
        '$baseUrl/$theDeviceId/symptoms/$toBeDeletedItemId.json';
    final existingSymptomIndex =
        _items.indexWhere((symptom) => symptom.id == id);
    var existingSymptom = _items[existingSymptomIndex];
    _items.removeAt(existingSymptomIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(existingSymptomIndex, existingSymptom);
      notifyListeners();
      throw HttpException('Could not delete symptom.');
    }
    existingSymptom = null;
  }
}
