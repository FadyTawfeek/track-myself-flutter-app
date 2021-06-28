import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class NormalMedicationItem {
  final String id;
  final String taken_med_name;
  final DateTime taken_dateTime;
  final String taken_amount;

  NormalMedicationItem({
    @required this.id,
    @required this.taken_med_name,
    @required this.taken_dateTime,
    @required this.taken_amount,
  });
}

class NormalMedications with ChangeNotifier {
  List<NormalMedicationItem> _items = [];

  List<NormalMedicationItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  NormalMedicationItem findById(String id) {
    return _items
        .firstWhere((normalMedicationItem) => normalMedicationItem.id == id);
  }

  Future<void> fetchNormalMedications() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedications.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<NormalMedicationItem> loadedNormalMedications = [];

      extractedData.forEach((normalMedId, normalMedData) {
        loadedNormalMedications.add(NormalMedicationItem(
          id: normalMedData['id'],
          taken_med_name: normalMedData['taken_med_name'],
          taken_dateTime: DateTime.parse(normalMedData['taken_dateTime']),
          taken_amount: normalMedData['taken_amount'],
        ));
      });
      _items = loadedNormalMedications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNormalMedication(NormalMedicationItem normalMedItem) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedications.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': normalMedItem.id,
          'taken_med_name': normalMedItem.taken_med_name,
          'taken_dateTime': normalMedItem.taken_dateTime.toIso8601String(),
          'taken_amount': normalMedItem.taken_amount,
        }),
      );
      final newNormalMedicationItem = NormalMedicationItem(
        id: normalMedItem.id,
        taken_med_name: normalMedItem.taken_med_name,
        taken_dateTime: normalMedItem.taken_dateTime,
        taken_amount: normalMedItem.taken_amount,
      );
      _items.add(newNormalMedicationItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteNormalMedication(String id) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedications.json';
    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      extractedData.forEach((normalMedId, normalMedData) {
        if (normalMedData['id'] == id) {
          toBeDeletedItemId = normalMedId;
        }
      });
      notifyListeners();
    } catch (error) {
      throw (error);
    }

    final deleteUrl =
        '$baseUrl/$theDeviceId/normalmedications/$toBeDeletedItemId.json';
    final existingNormalMedicationIndex =
        _items.indexWhere((item) => item.id == id);
    var existingNormalMedication = _items[existingNormalMedicationIndex];
    _items.removeAt(existingNormalMedicationIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(existingNormalMedicationIndex, existingNormalMedication);
      notifyListeners();
      throw HttpException('Could not delete normal medication.');
    }
    existingNormalMedication = null;
  }
}
