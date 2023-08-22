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

  Future clearPendingApproval() async {
    return _prefService.clearPendingApproval();
  }

  Future logout() {
    return _prefService.clearTokens();
  }

  String getApprovalText(int status) {
    if (status < 0) {
      return 'Akun Anda tidak disetujui oleh Admin.';
    }

    return 'Akun Anda sedang menunggu persetujuan dari Admin.';
  }
}