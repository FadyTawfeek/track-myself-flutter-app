import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class DefaultMedicationItem {
  final String id;
  final String default_med_name;
  final String amount;

  DefaultMedicationItem({
    @required this.id,
    @required this.default_med_name,
    @required this.amount,
  });
}

class DefaultMedications with ChangeNotifier {
  List<DefaultMedicationItem> _items = [];

  List<DefaultMedicationItem> get items {
    return [..._items];
  }

  List<DefaultMedicationItem> _items2 = [];

  List<DefaultMedicationItem> get items2 {
    return [..._items2];
  }

  List<DefaultMedicationItem> _items3 = [];

  List<DefaultMedicationItem> get items3 {
    return [..._items3];
  }

  List<String> _medicationNames = [];

  List<String> get medicationNames {
    return [..._medicationNames];
  }

  int get itemCount {
    return _items.length;
  }

  DefaultMedicationItem findById(String id) {
    return _items
        .firstWhere((defaultMedicationItem) => defaultMedicationItem.id == id);
  }

  Future<void> findByName(String name) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedications.json';

    //const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _items3 = [];
        return;
      }

      final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        loadedDefaultMedications.add(DefaultMedicationItem(
          id: defaultMedData['id'],
          default_med_name: defaultMedData['default_med_name'],
          amount: defaultMedData['amount'],
        ));
      });

      _items2 = loadedDefaultMedications;

      _items3 = [];
      var foundItem;

      foundItem = _items2.firstWhere(
          (defaultMedicationItem) =>
              defaultMedicationItem.default_med_name == name,
          orElse: () => null);

      if (foundItem != null) {
        _items3.add(foundItem);
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchDefaultMedications() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedications.json';
    //const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        loadedDefaultMedications.add(DefaultMedicationItem(
          id: defaultMedData['id'],
          default_med_name: defaultMedData['default_med_name'],
          amount: defaultMedData['amount'],
        ));
      });
      _items = loadedDefaultMedications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addDefaultMedication(
      DefaultMedicationItem defaultMedItem) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedications.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': defaultMedItem.id,
          'default_med_name': defaultMedItem.default_med_name,
          'amount': defaultMedItem.amount,
        }),
      );
      final newDefaultMedicationItem = DefaultMedicationItem(
        id: defaultMedItem.id,
        default_med_name: defaultMedItem.default_med_name,
        amount: defaultMedItem.amount,
      );
      _items.add(newDefaultMedicationItem);

      notifyListeners();
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  Future<void> deleteDefaultMedication(String id) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedications.json';

    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((defaultMedId, defaultMedData) {
        if (defaultMedData['id'] == id) {
          toBeDeletedItemId = defaultMedId;
        }
      });

      notifyListeners();
    } catch (error) {
      throw (error);
    }

    final deleteUrl =
        '$baseUrl/$theDeviceId/defaultmedications/$toBeDeletedItemId.json';
    final existingDefaultMedicationIndex =
        _items.indexWhere((item) => item.id == id);
    var existingDefaultMedication = _items[existingDefaultMedicationIndex];
    _items.removeAt(existingDefaultMedicationIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(existingDefaultMedicationIndex, existingDefaultMedication);
      notifyListeners();
      throw HttpException('Could not delete default medication.');
    }
    existingDefaultMedication = null;
  }
}
