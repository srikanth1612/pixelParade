import 'package:flutter/services.dart';

class SharedStorageService {
  static const platform = MethodChannel('com.pixelParade.sharedStorage');

  // Save data to shared storage
  Future<void> saveDataToCoreData(String key, String value) async {
    try {
      await platform.invokeMethod('saveData', {'key': key, 'value': value});
    } on PlatformException catch (e) {
      print("Failed to save data to Core Data: ${e.message}");
    }
  }

  // Retrieve data from shared storage
  Future<String?> retrieveDataFromCoreData(String key) async {
    try {
      final result = await platform.invokeMethod('retrieveData', {'key': key});
      print(result);
      return result as String?;
    } on PlatformException catch (e) {
      print("Failed to retrieve data from Core Data: ${e.message}");
      return null;
    }
  }

  void getData() async {
    String key = "yourKey";
    String? value = await retrieveDataFromCoreData(key);
    if (value != null) {
      print("Retrieved value: $value");
    } else {
      print("No value found for the given key.");
    }
  }
}
