import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/services/prefs_service.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class PendingViewModel extends FutureViewModel<int> {
  final _prefService = locator<PrefsService>();
  final _userService = locator<UserService>();

  @override
  Future<int> futureToRun() {
    return getApprovalStatus();
  }

  Future<int> getApprovalStatus() async {
    setBusy(true);
    int status = await _userService.getApprovalStatus();
    setBusy(false);

    return status;
  }

  /// Set current user is approved.
  void setUserApproved() {
    _prefService.setUserApproved(true);
  }

  /// Get user approval message.
  /// -1: Declined, 0: Pending, 1: Approved.
  String getApprovalText(int status) {
    if (status < 0) {
      return 'Akun Anda tidak disetujui oleh Admin.';
    }

    return 'Akun Anda sedang menunggu persetujuan dari Admin.';
  }

  /// Log user out by clearing all prefs.
  void logout() {
    _prefService.clearPrefs();
  }
}