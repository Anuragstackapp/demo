import 'package:shared_preferences/shared_preferences.dart';

 Future<bool> checkPrefKey(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

Future<bool> setPrefKey(String key,value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, value);
}

Future<bool> removePrefkey(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.remove(key);
}