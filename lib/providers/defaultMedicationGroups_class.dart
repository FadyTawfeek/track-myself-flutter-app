import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'defaultMedication_class.dart';
import 'dart:convert';

import '../models/baseUrl.dart' as baseUrlImport;

final baseUrl = baseUrlImport.baseUrl;

class DefaultMedicationGroup {
  final String id;
  final String default_group_name;
  final String default_time;
  final List<DefaultMedicationItem> listOfMedicationItems;

  DefaultMedicationGroup({
    @required this.id,
    @required this.default_group_name,
    @required this.default_time,
    @required this.listOfMedicationItems,
  });
}

class SortingDefaultMedicationGroup {
  final String default_group_name;
  final String time;

  SortingDefaultMedicationGroup({
    @required this.default_group_name,
    @required this.time,
  });
}

class DefaultMedicationsGroups with ChangeNotifier {
  List<DefaultMedicationGroup> _items = [];

  List<DefaultMedicationGroup> get items {
    return [..._items];
  }

  List<DefaultMedicationGroup> _items2 = [];

  List<DefaultMedicationGroup> get items2 {
    return [..._items2];
  }

  List<DefaultMedicationGroup> _items3 = [];

  List<DefaultMedicationGroup> get items3 {
    return [..._items3];
  }

  List<SortingDefaultMedicationGroup> _sortedList = [];

  List<SortingDefaultMedicationGroup> get sortedList {
    return [..._sortedList];
  }

  List<String> _medicationNames = [];

  List<String> get medicationNames {
    return [..._medicationNames];
  }

  int get itemCount {
    return _items.length;
  }

  DefaultMedicationGroup findById(String id) {
    return _items.firstWhere(
        (defaultMedicationGroup) => defaultMedicationGroup.id == id);
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
    final url = '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        _items3 = [];
        return;
      }
      final List<DefaultMedicationGroup> loadedDefaultMedicationsGroups = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        List<DefaultMedicationItem> theList = [];

        for (var i = 0;
            i < defaultMedData['listOfMedicationItems'].length;
            i++) {
          var toBeLoadedDefaultMedicationItem =
              defaultMedData['listOfMedicationItems'][i];
          DefaultMedicationItem loadedDefaultMedicationItem =
              DefaultMedicationItem(
                  id: toBeLoadedDefaultMedicationItem['id'],
                  default_med_name:
                      toBeLoadedDefaultMedicationItem['default_med_name'],
                  amount: toBeLoadedDefaultMedicationItem['amount']);

          theList.add(loadedDefaultMedicationItem);
        }

        loadedDefaultMedicationsGroups.add(DefaultMedicationGroup(
            id: defaultMedData['id'],
            default_group_name: defaultMedData['default_group_name'],
            default_time: defaultMedData['default_time'],
            listOfMedicationItems: theList));
      });

      _items2 = loadedDefaultMedicationsGroups;
      _items3 = [];
      var foundItem;

      foundItem = _items2.firstWhere(
          (defaultMedicationGroup) =>
              defaultMedicationGroup.default_group_name == name,
          orElse: () => null);

      if (foundItem != null) {
        _items3.add(foundItem);
      }

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchDefaultMedicationsGroups() async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<DefaultMedicationGroup> loadedDefaultMedicationsGroups = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        List<DefaultMedicationItem> theList = [];

        for (var i = 0;
            i < defaultMedData['listOfMedicationItems'].length;
            i++) {
          var toBeLoadedDefaultMedicationItem =
              defaultMedData['listOfMedicationItems'][i];
          DefaultMedicationItem loadedDefaultMedicationItem =
              DefaultMedicationItem(
                  id: toBeLoadedDefaultMedicationItem['id'],
                  default_med_name:
                      toBeLoadedDefaultMedicationItem['default_med_name'],
                  amount: toBeLoadedDefaultMedicationItem['amount']);

          theList.add(loadedDefaultMedicationItem);
        }

        loadedDefaultMedicationsGroups.add(DefaultMedicationGroup(
          id: defaultMedData['id'],
          default_group_name: defaultMedData['default_group_name'],
          default_time: defaultMedData['default_time'],
          listOfMedicationItems: theList,
        ));
      });
      _items = loadedDefaultMedicationsGroups;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSortDefaultMedicationsGroups() async {
    final extractedData = _items;
    if (extractedData == null) {
      return;
    }
    final List<SortingDefaultMedicationGroup>
        toBeSortedDefaultMedicationsGroups = [];

    int index = 0;

    extractedData.forEach((element) {
      toBeSortedDefaultMedicationsGroups.add(SortingDefaultMedicationGroup(
        default_group_name: element.default_group_name,
        time: element.default_time,
      ));
      index = index + 1;
    });
    _sortedList = toBeSortedDefaultMedicationsGroups;
    Comparator<SortingDefaultMedicationGroup> timeIntComparator =
        (a, b) => a.time.compareTo(b.time);
    _sortedList.sort(timeIntComparator);

    notifyListeners();
  }

  Future<void> addDefaultMedicationGroup(
      DefaultMedicationGroup defaultMedGroup) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': defaultMedGroup.id,
          'default_group_name': defaultMedGroup.default_group_name,
          'default_time': defaultMedGroup.default_time,
          'listOfMedicationItems': [
            for (var i = 0;
                i < defaultMedGroup.listOfMedicationItems.length;
                i++)
              {
                "id": defaultMedGroup.listOfMedicationItems[i].id,
                "default_med_name":
                    defaultMedGroup.listOfMedicationItems[i].default_med_name,
                "amount": defaultMedGroup.listOfMedicationItems[i].amount
              }
          ]
        }),
      );
      final newDefaultMedicationGroup = DefaultMedicationGroup(
          id: defaultMedGroup.id,
          default_group_name: defaultMedGroup.default_group_name,
          default_time: defaultMedGroup.default_time,
          listOfMedicationItems: defaultMedGroup.listOfMedicationItems);
      _items.add(newDefaultMedicationGroup);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDefaultMedicationGroup(String id) async {
    String theDeviceId;
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      theDeviceId = iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      theDeviceId = androidDeviceInfo.androidId;
    }
    final url = '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';
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
        '$baseUrl/$theDeviceId/defaultmedicationsgroups/$toBeDeletedItemId.json';
    final existingDefaultMedicationGroupIndex =
        _items.indexWhere((item) => item.id == id);
    var existingDefaultMedicationGroup =
        _items[existingDefaultMedicationGroupIndex];
    _items.removeAt(existingDefaultMedicationGroupIndex);
    notifyListeners();
    final response = await http.delete(deleteUrl);
    if (response.statusCode >= 400) {
      _items.insert(
          existingDefaultMedicationGroupIndex, existingDefaultMedicationGroup);
      notifyListeners();
      throw HttpException('Could not delete default medication group.');
    }
    existingDefaultMedicationGroup = null;
  }
}
