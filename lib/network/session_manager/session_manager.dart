import 'package:pixel_parade/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _sessionManager = SessionManager._internal();

  factory SessionManager() {
    return _sessionManager;
  }

  SessionManager._internal();

  static final Future<SharedPreferences> _pref =
      SharedPreferences.getInstance();

  static void setToken(String token) {
    _pref.then((value) => value.setString(StorageStrings.token, token));
  }

  static Future<String?> getToken() {
    return _pref.then((value) => value.getString(StorageStrings.token) ?? '');
  }

  static void setUserEmail(String email) {
    _pref.then((value) => value.setString(StorageStrings.userEmail, email));
  }

  static Future<String?> getUserEmail() {
    return _pref
        .then((value) => value.getString(StorageStrings.userEmail) ?? '');
  }
}
