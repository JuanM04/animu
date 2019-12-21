import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> setDefaultSetting(
  SharedPreferences prefs,
  String key,
  dynamic value,
) {
  switch (value.runtimeType) {
    case int:
      if (prefs.getInt(key) == null) return prefs.setInt(key, value);
      break;
    case double:
      if (prefs.getDouble(key) == null) return prefs.setDouble(key, value);
      break;
    case bool:
      if (prefs.getBool(key) == null) return prefs.setBool(key, value);
      break;
    case String:
      if (prefs.getString(key) == null) return prefs.setString(key, value);
      break;
    case List:
      if (prefs.getStringList(key) == null)
        return prefs.setStringList(key, value);
      break;
    default:
  }
  return Future.delayed(Duration(milliseconds: 1));
}
