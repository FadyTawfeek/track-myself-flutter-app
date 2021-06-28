import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'defaultMedication_class.dart';

import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class NormalMedicationGroup {
  final String id;
  final String normal_group_name;
  final String optimal_time;
  final DateTime taken_dateTime;
  final List<DefaultMedicationItem> listOfMedicationItems;

  NormalMedicationGroup({
    @required this.id,
    @required this.normal_group_name,
    @required this.optimal_time,
    @required this.taken_dateTime,
    @required this.listOfMedicationItems,
  });
}

class NormalMedicationsGroups with ChangeNotifier {
  List<NormalMedicationGroup> _items = [];

  List<NormalMedicationGroup> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  NormalMedicationGroup findById(String id) {
    return _items
        .firstWhere((normalMedicationGroup) => normalMedicationGroup.id == id);
  }

  Future<void> fetchNormalMedicationsGroups() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedicationsgroups.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<NormalMedicationGroup> loadedNormalMedicationsGroups = [];

      extractedData.forEach((normalMedId, normalMedData) {
        List<DefaultMedicationItem> theList = [];

        for (var i = 0;
            i < normalMedData['listOfMedicationItems'].length;
            i++) {
          var toBeLoadedDefaultMedicationItem =
              normalMedData['listOfMedicationItems'][i];
          DefaultMedicationItem loadedDefaultMedicationItem =
              DefaultMedicationItem(
                  id: toBeLoadedDefaultMedicationItem['id'],
                  default_med_name:
                      toBeLoadedDefaultMedicationItem['default_med_name'],
                  amount: toBeLoadedDefaultMedicationItem['amount']);

          theList.add(loadedDefaultMedicationItem);
        }

        loadedNormalMedicationsGroups.add(NormalMedicationGroup(
          id: normalMedData['id'],
          normal_group_name: normalMedData['normal_group_name'],
          optimal_time: normalMedData['optimal_time'],
          taken_dateTime: DateTime.parse(normalMedData['taken_dateTime']),
          listOfMedicationItems: theList,
        ));
      });
      _items = loadedNormalMedicationsGroups;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addNormalMedicationGroup(
      NormalMedicationGroup normalMedGroup) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedicationsgroups.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': normalMedGroup.id,
          'normal_group_name': normalMedGroup.normal_group_name,
          'optimal_time': normalMedGroup.optimal_time,
          'taken_dateTime': normalMedGroup.taken_dateTime.toIso8601String(),
          'listOfMedicationItems': [
            for (var i = 0;
                i < normalMedGroup.listOfMedicationItems.length;
                i++)
              {
                "id": normalMedGroup.listOfMedicationItems[i].id,
                "default_med_name":
                    normalMedGroup.listOfMedicationItems[i].default_med_name,
                "amount": normalMedGroup.listOfMedicationItems[i].amount
              }
          ]
        }),
      );
      final newNormalMedicationGroup = NormalMedicationGroup(
        id: normalMedGroup.id,
        normal_group_name: normalMedGroup.normal_group_name,
        optimal_time: normalMedGroup.optimal_time,
        taken_dateTime: normalMedGroup.taken_dateTime,
        listOfMedicationItems: normalMedGroup.listOfMedicationItems,
      );
      _items.add(newNormalMedicationGroup);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteNormalMedicationGroup(String id) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/normalmedicationsgroups.json';

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
        '$baseUrl/$theDeviceId/normalmedicationsgroups/$toBeDeletedItemId.json';
    final existingNormalMedicationGroupIndex =
        _items.indexWhere((item) => item.id == id);
    var existingNormalMedicationGroup =
        _items[existingNormalMedicationGroupIndex];
    _items.removeAt(existingNormalMedicationGroupIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(
          existingNormalMedicationGroupIndex, existingNormalMedicationGroup);
      notifyListeners();
      throw HttpException('Could not delete normal medication group.');
    }
    existingNormalMedicationGroup = null;
  }
}
