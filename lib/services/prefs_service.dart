import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  SharedPreferences? _prefs;

  SharedPreferences? get prefs => _prefs;

  Future<SharedPreferences?> getPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future setTokens(String accessToken, String refreshToken) async {
    if (_prefs == null) await getPrefs();
    _prefs!.setString('accessToken', accessToken);
    _prefs!.setString('refreshToken', refreshToken);
  }

  Future<String?> getAccessToken() async {
    if (_prefs == null) await getPrefs();
    return _prefs!.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    if (_prefs == null) await getPrefs();
    return _prefs!.getString('refreshToken');
  }

  Future setPendingApproval(bool value) async {
    if (_prefs == null) await getPrefs();
    _prefs!.setBool('pendingApproval', true);
  }

  Future<bool?> isPendingApproval() async {
    if (_prefs == null) await getPrefs();
    return _prefs!.getBool('pendingApproval');
  }

  Future clearPendingApproval() async {
    if (_prefs == null) await getPrefs();
    _prefs!.remove('pendingApproval');
  }

  Future clearTokens() async {
    if (_prefs == null) return;

    _prefs!.remove('accessToken');
    _prefs!.remove('refreshToken');
  }
}