import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> securedRead(String key) async {
    return await _storage.read(key: key.toString());
  }

  static Future<void> securedWrite(String key, String data) async {
    await _storage.write(key: key.toString(), value: data);
  }

  static Future<SharedPreferences> preference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}