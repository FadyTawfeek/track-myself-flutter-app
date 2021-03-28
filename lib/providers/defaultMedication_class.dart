//import 'dart:html';
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
  // final String default_time1;
  // final String default_time2;
  // final String default_time3;
  // final String default_time4;
  // final String default_time5;
  final String amount;

  DefaultMedicationItem({
    @required this.id,
    @required this.default_med_name,
    @required this.amount,
  });
  // Map toJson() => {
  //       "id": this.id,
  //       "default_med_name": this.default_med_name,
  //       "amount": this.amount,
  //     };
}

// class SortingDefaultMedicationItem {
//   final int index;
//   final String default_med_name;
//   final String time;
//   final int timeInt;

//   SortingDefaultMedicationItem({
//     @required this.index,
//     @required this.default_med_name,
//     @required this.time,
//     @required this.timeInt,
//   });
// }

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

  // List<SortingDefaultMedicationItem> _listBeforeSorting = [];

  // List<SortingDefaultMedicationItem> get listBeforeSorting {
  //   return [..._listBeforeSorting];
  // }

  // List<SortingDefaultMedicationItem> _sortedList = [];

  // List<SortingDefaultMedicationItem> get sortedList {
  //   return [..._sortedList];
  // }

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
    final url = '$baseUrl/$theDeviceId/defaultmedications.json';

    //const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _items3 = [];
        return;
      }
      //print("1: $_items3");
      final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);
        loadedDefaultMedications.add(DefaultMedicationItem(
          id: defaultMedData['id'],
          default_med_name: defaultMedData['default_med_name'],
          amount: defaultMedData['amount'],
        ));
      });
      //print("2: $_items3");
      _items2 = loadedDefaultMedications;
      //print("items 2: $_items2");
      _items3 = [];
      var foundItem;

      foundItem = _items2.firstWhere(
          (defaultMedicationItem) =>
              defaultMedicationItem.default_med_name == name,
          orElse: () => null);

      if (foundItem != null) {
        _items3.add(foundItem);
        //print("items 3: ${_items3[0].default_med_name}");
      }

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

  // DefaultMedicationItem findById(String id) {
  //   return _items
  //       .firstWhere((defaultMedicationItem) => defaultMedicationItem.id == id);
  // }

  // DefaultMedicationItem findByName(String name) {
  //   return _items.firstWhere((defaultMedicationItem) =>
  //       defaultMedicationItem.default_med_name == name);
  // }

  // Future<void> findByNameGiveBack(String name) async {
  //   const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     //print("1: $_items3");
  //     final List<DefaultMedicationItem> loadedDefaultMedications = [];

  //     extractedData.forEach((defaultMedId, defaultMedData) {
  //       //String s = "6:00 AM";
  //       //String s = defaultMedData['default_time1'];
  //       //print(s);
  //       loadedDefaultMedications.add(DefaultMedicationItem(
  //         id: defaultMedData['id'],
  //         default_med_name: defaultMedData['default_med_name'],
  //         amount: defaultMedData['amount'],
  //       ));
  //     });
  //     //print("2: $_items3");
  //     _items2 = loadedDefaultMedications;
  //     //print("items 2: $_items2");
  //     _items3 = [];
  //     var foundItem;

  //     foundItem = _items2.firstWhere(
  //         (defaultMedicationItem) =>
  //             defaultMedicationItem.default_med_name == name,
  //         orElse: () => null);

  //     if (foundItem != null) {
  //       _items3.add(foundItem);
  //     }

  //     //print("3: $_items3");
  //     //print("default name is ${_items3[0].default_med_name}");
  //     //print(_items3[0].default_med_name);
  //     notifyListeners();

  //     // return _items2.firstWhere((defaultMedicationItem) =>
  //     //     defaultMedicationItem.default_med_name == name);
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

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
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);
        loadedDefaultMedications.add(DefaultMedicationItem(
          id: defaultMedData['id'],
          default_med_name: defaultMedData['default_med_name'],
          //defaultMedData['default_time1'],
          //(hour: s.split(":")[0], minute: s.split(":")[1])
          amount: defaultMedData['amount'],
        ));
      });
      _items = loadedDefaultMedications;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // Future<void> fetchAndSortDefaultMedications() async {
  //   const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     final List<SortingDefaultMedicationItem> toBeSortedDefaultMedications =
  //         [];

  //     int index = 0;

  //     extractedData.forEach((defaultMedId, defaultMedData) {
  //       //String s = "6:00 AM";
  //       //String s = defaultMedData['default_time1'];
  //       //print(s);

  //       toBeSortedDefaultMedications.add(SortingDefaultMedicationItem(
  //         index: index,
  //         default_med_name: defaultMedData['default_med_name'],
  //         time: defaultMedData['default_time1'],
  //         timeInt:
  //             (int.parse(defaultMedData['default_time1'].substring(0, 2)) * 60 +
  //                 int.parse(defaultMedData['default_time1'].substring(3))),
  //       ));
  //       index = index + 1;

  //       if (defaultMedData['default_time2'] != null) {
  //         toBeSortedDefaultMedications.add(SortingDefaultMedicationItem(
  //           index: index,
  //           default_med_name: defaultMedData['default_med_name'],
  //           time: defaultMedData['default_time2'],
  //           timeInt:
  //               (int.parse(defaultMedData['default_time2'].substring(0, 2)) *
  //                       60 +
  //                   int.parse(defaultMedData['default_time2'].substring(3))),
  //         ));
  //         index = index + 1;
  //       }

  //       if (defaultMedData['default_time3'] != null) {
  //         toBeSortedDefaultMedications.add(SortingDefaultMedicationItem(
  //           index: index,
  //           default_med_name: defaultMedData['default_med_name'],
  //           time: defaultMedData['default_time3'],
  //           timeInt:
  //               (int.parse(defaultMedData['default_time3'].substring(0, 2)) *
  //                       60 +
  //                   int.parse(defaultMedData['default_time3'].substring(3))),
  //         ));
  //         index = index + 1;
  //       }

  //       if (defaultMedData['default_time4'] != null) {
  //         toBeSortedDefaultMedications.add(SortingDefaultMedicationItem(
  //           index: index,
  //           default_med_name: defaultMedData['default_med_name'],
  //           time: defaultMedData['default_time4'],
  //           timeInt:
  //               (int.parse(defaultMedData['default_time4'].substring(0, 2)) *
  //                       60 +
  //                   int.parse(defaultMedData['default_time4'].substring(3))),
  //         ));
  //         index = index + 1;
  //       }

  //       if (defaultMedData['default_time5'] != null) {
  //         toBeSortedDefaultMedications.add(SortingDefaultMedicationItem(
  //           index: index,
  //           default_med_name: defaultMedData['default_med_name'],
  //           time: defaultMedData['default_time5'],
  //           timeInt:
  //               (int.parse(defaultMedData['default_time5'].substring(0, 2)) *
  //                       60 +
  //                   int.parse(defaultMedData['default_time5'].substring(3))),
  //         ));
  //         index = index + 1;
  //       }
  //     });
  //     _sortedList = toBeSortedDefaultMedications;
  //     // for (var i = 0; i < _listBeforeSorting.length; i++) {
  //     //   print(_listBeforeSorting[i].default_med_name);
  //     // }

  //     //int calculatedTimeDifference = 999999999;

  //     //int minimum = 0;
  //     // for (var i = 0; i < _listBeforeSorting.length; i++) {
  //     //   print(_listBeforeSorting[i].default_med_name);
  //     // }
  //     Comparator<SortingDefaultMedicationItem> timeIntComparator =
  //         (a, b) => a.timeInt.compareTo(b.timeInt);
  //     _sortedList.sort(timeIntComparator);
  //     //_listBeforeSorting.sort()

  //     // _sortedList.forEach((SortingDefaultMedicationItem item) {
  //     //   print('${item.default_med_name} - ${item.time} - ${item.timeInt}');
  //     // });

  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

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
    //const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
    //final timestamp = time.toString();
    //toIso8601String();
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
        //json.decode(response.body)['name'],
        default_med_name: defaultMedItem.default_med_name,
        amount: defaultMedItem.amount,
      );
      _items.add(newDefaultMedicationItem);
      // _items.insert(0, newProduct); // at the start of the list
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
    //String toBeDeletedItemId = _items.firstWhere((element) => element.id == id).id;
    //const url = 'https://stop1-8af28.firebaseio.com/defaultmedications.json';
    String toBeDeletedItemId;
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      //final List<DefaultMedicationItem> loadedDefaultMedications = [];

      extractedData.forEach((defaultMedId, defaultMedData) {
        //String s = "6:00 AM";
        //String s = defaultMedData['default_time1'];
        //print(s);

        if (defaultMedData['id'] == id) {
          toBeDeletedItemId = defaultMedId;
        }
      });
      //_items = loadedDefaultMedications;
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
