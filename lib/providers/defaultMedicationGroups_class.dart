//import 'dart:html';
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
  //final int timeInt;

  SortingDefaultMedicationGroup({
    @required this.default_group_name,
    @required this.time,
    //@required this.timeInt,
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

  // List<SortingDefaultMedicationItem> _listBeforeSorting = [];

  // List<SortingDefaultMedicationItem> get listBeforeSorting {
  //   return [..._listBeforeSorting];
  // }

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

  // DefaultMedicationItem findByName(String name) {
  //   return _items.firstWhere((defaultMedicationItem) =>
  //       defaultMedicationItem.default_med_name == name);
  // }

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
    final url =
        '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';

    // const url =
    //     'https://stop1-8af28.firebaseio.com/defaultmedicationsgroups.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //print(extractedData);
      if (extractedData == null) {
        _items3 = [];
        return;
      }
      //print("1: $_items3");
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
            //defaultMedData['default_time1'],
            //(hour: s.split(":")[0], minute: s.split(":")[1])
            listOfMedicationItems: theList
            //theList,
            ));
      });

      _items2 = loadedDefaultMedicationsGroups;
      //print("items 2: $_items2");
      _items3 = [];
      var foundItem;

      foundItem = _items2.firstWhere(
          (defaultMedicationGroup) =>
              defaultMedicationGroup.default_group_name == name,
          orElse: () => null);

      if (foundItem != null) {
        _items3.add(foundItem);
        //print("items 3: ${_items3[0].default_group_name}");
      }
      //print("222222: $_items3");

      //print("3: $_items3");
      //print("default name is ${_items3[0].default_med_name}");
      //print(_items3[0].default_med_name);
      notifyListeners();

      // return _items2.firstWhere((defaultMedicationItem) =>
      //     defaultMedicationItem.default_med_name == name);
    } catch (error) {
      throw (error);
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

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
    final url =
        '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';
    // const url =
    //     'https://stop1-8af28.firebaseio.com/defaultmedicationsgroups.json';
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
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);
        loadedDefaultMedicationsGroups.add(DefaultMedicationGroup(
          id: defaultMedData['id'],
          default_group_name: defaultMedData['default_group_name'],
          default_time: defaultMedData['default_time'],
          //defaultMedData['default_time1'],
          //(hour: s.split(":")[0], minute: s.split(":")[1])
          listOfMedicationItems: theList,
        ));
      });
      _items = loadedDefaultMedicationsGroups;
      //print(_items[0].default_group_name);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSortDefaultMedicationsGroups() async {
    // String theDeviceId;
    // var deviceInfo = DeviceInfoPlugin();
    // if (Platform.isIOS) {
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   theDeviceId = iosDeviceInfo.identifierForVendor;
    // } else {
    //   var androidDeviceInfo = await deviceInfo.androidInfo;
    //   theDeviceId = androidDeviceInfo.androidId;
    // }
    // final url =
    //     'https://stop1-8af28.firebaseio.com/$theDeviceId/defaultmedicationsgroups.json';
    // const url =
    //     'https://stop1-8af28.firebaseio.com/defaultmedicationsgroups.json';
    //try {
    //final response = await http.get(url);
    final extractedData = _items;
    //as Map<String, dynamic>;
    //json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<SortingDefaultMedicationGroup>
        toBeSortedDefaultMedicationsGroups = [];

    int index = 0;

    extractedData.forEach((element) {
      //String s = "6:00 AM";
      //String s = defaultMedData['default_time1'];
      //print(s);

      toBeSortedDefaultMedicationsGroups.add(SortingDefaultMedicationGroup(
        default_group_name: element.default_group_name,
        time: element.default_time,
        // timeInt:
        //     (int.parse(defaultMedData['default_time1'].substring(0, 2)) * 60 +
        //         int.parse(defaultMedData['default_time1'].substring(3))),
      ));
      index = index + 1;
    });
    _sortedList = toBeSortedDefaultMedicationsGroups;
    // for (var i = 0; i < _listBeforeSorting.length; i++) {
    //   print(_listBeforeSorting[i].default_med_name);
    // }

    //int calculatedTimeDifference = 999999999;

    //int minimum = 0;
    // for (var i = 0; i < _listBeforeSorting.length; i++) {
    //   print(_listBeforeSorting[i].default_med_name);
    // }
    Comparator<SortingDefaultMedicationGroup> timeIntComparator =
        (a, b) => a.time.compareTo(b.time);
    _sortedList.sort(timeIntComparator);
    //_listBeforeSorting.sort()

    // _sortedList.forEach((SortingDefaultMedicationItem item) {
    //   print('${item.default_med_name} - ${item.time} - ${item.timeInt}');
    // });

    notifyListeners();
    //}
    // catch (error) {
    //   throw (error);
    // }
  }

  // Future<void> fetchDefaultMedicationsTimes() async {
  //   const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     final List<DefaultMedicationItem> loadedDefaultMedicationsTimes = [];

  //     extractedData.forEach((defaultMedId, defaultMedData) {
  //       //String s = "6:00 AM";
  //       //String s = defaultMedData['default_time1'];
  //       //print(s);
  //       loadedDefaultMedicationsTimes.add(DefaultMedicationItem(
  //         id: defaultMedId,
  //         default_med_name: defaultMedData['default_med_name'],
  //         default_time1: defaultMedData['default_time1'],
  //         //defaultMedData['default_time1'],
  //         //(hour: s.split(":")[0], minute: s.split(":")[1])
  //         default_time2: defaultMedData['default_time2'],
  //         default_time3: defaultMedData['default_time3'],
  //         default_time4: defaultMedData['default_time4'],
  //         default_time5: defaultMedData['default_time5'],
  //         default_number_of_pills: defaultMedData['default_number_of_pills'],
  //       ));
  //     });
  //     _items = loadedDefaultMedicationsTimes;
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // Future<void> fetchDefaultMedicationsNames() async {
  //   const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     final List<DefaultMedicationItem> loadedDefaultMedications = [];

  //     extractedData.forEach((defaultMedId, defaultMedData) {
  //       //String s = "6:00 AM";
  //       //String s = defaultMedData['default_time1'];
  //       //print(s);
  //       loadedDefaultMedications.add(DefaultMedicationItem(
  //         id: defaultMedId,
  //         default_med_name: defaultMedData['default_med_name'],
  //         default_time1: defaultMedData['default_time1'],
  //         //defaultMedData['default_time1'],
  //         //(hour: s.split(":")[0], minute: s.split(":")[1])
  //         default_time2: defaultMedData['default_time2'],
  //         default_time3: defaultMedData['default_time3'],
  //         default_time4: defaultMedData['default_time4'],
  //         default_time5: defaultMedData['default_time5'],
  //         default_number_of_pills: defaultMedData['default_number_of_pills'],
  //       ));
  //     });
  //     _items = loadedDefaultMedications;
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

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
    final url =
        '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': defaultMedGroup.id,
          'default_group_name': defaultMedGroup.default_group_name,
          'default_time': defaultMedGroup.default_time,
          'listOfMedicationItems':
              //theFinalList as List<DefaultMedicationItem>
              [
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
      //print("response is ");
      //print(response);
      final newDefaultMedicationGroup = DefaultMedicationGroup(
          id: defaultMedGroup.id,
          //json.decode(response.body)['name'],
          default_group_name: defaultMedGroup.default_group_name,
          default_time: defaultMedGroup.default_time,
          listOfMedicationItems: defaultMedGroup.listOfMedicationItems
          //theList

          // .map<DefaultMedicationItem>((item) => new DefaultMedicationItem(
          //     id: defaultMedGroup.listOfMedicationItems[0].id,
          //     default_med_name:
          //         defaultMedGroup.listOfMedicationItems[0].default_med_name,
          //     amount: defaultMedGroup.listOfMedicationItems[0].amount))
          // .toList()
          // .cast<DefaultMedicationItem>()
          );
      _items.add(newDefaultMedicationGroup);
      //print("_itemsss: ${_items[0].default_group_name}");
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      //print(error);
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
    final url =
        '$baseUrl/$theDeviceId/defaultmedicationsgroups.json';
    // const url =
    //     'https://stop1-8af28.firebaseio.com/defaultmedicationsgroups.json';
    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //final List<DefaultMedicationGroup> loadedDefaultMedicationsGroups = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        if (defaultMedData['id'] == id) {
          toBeDeletedItemId = defaultMedId;
        }
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);
      });
      //_items = loadedDefaultMedicationsGroups;
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
