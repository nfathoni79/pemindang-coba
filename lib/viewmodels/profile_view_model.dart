import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/user.dart';
import 'package:pemindang_coba/services/prefs_service.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends MultipleFutureViewModel {
  static const String userKey = 'user';

  final _prefService = locator<PrefsService>();
  final _userService = locator<UserService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    userKey: getCurrentUser,
  };

  bool get userBusy => busy(userKey);

  User get user => dataMap?[userKey];

  Future<User?> getCurrentUser() {
    return _userService.getCurrentUser();
  }

  /// Log user out by clearing all prefs.
  void logout() {
    _prefService.clearPrefs();
  }
}