import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/models/transaction.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class TransactionsViewModel extends MultipleFutureViewModel {
  static const String userKey = 'user';
  static const String trxKey = 'transactions';

  final _userService = locator<UserService>();

  @override
  Map<String, Future Function()> get futuresMap => {
    userKey: getSeaseedUser,
    trxKey: getTransactions,
  };

  bool get userBusy => busy(userKey);
  bool get trxBusy => busy(trxKey);

  SeaseedUser get seaseedUser => dataMap?[userKey];
  List<Transaction> get transactions => dataMap?[trxKey];

  Future<SeaseedUser?> getSeaseedUser() {
    return _userService.getCurrentSeaseedUser();
  }

  Future<List<Transaction>> getTransactions() {
    return _userService.getTransactions();
  }
}