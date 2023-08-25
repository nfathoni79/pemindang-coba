import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/bank.dart';
import 'package:pemindang_coba/models/deposit.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/models/transaction.dart';
import 'package:pemindang_coba/models/user.dart';
import 'package:pemindang_coba/models/user_token.dart';
import 'package:pemindang_coba/models/withdrawal.dart';
import 'package:pemindang_coba/services/lio_service.dart';

class UserService {
  final _lio = locator<LioService>();

  User? _currentUser;
  SeaseedUser? _currentSeaseedUser;
  List<SeaseedUser> _otherSeaseedUsers = [];
  List<Bank> _banks = [];
  List<Transaction> _transactions = [];

  User? get currentUser => _currentUser;

  SeaseedUser? get currentSeaseedUser => _currentSeaseedUser;

  List<SeaseedUser> get otherSeaseedUsers => _otherSeaseedUsers;

  List<Bank> get banks => _banks;

  List<Transaction> get transactions => _transactions;

  Future<UserToken> login(String username, String password) async {
    return _lio.getToken(username, password);
  }

  Future<bool> register(String username, String fullName, String phone,
      String email, String password, String confirmPassword) {
    return _lio.createUser(
        username, fullName, phone, email, password, confirmPassword);
  }

  Future<bool> createPendingApproval() async {
    return _lio.createPendingApproval();
  }

  Future<int> getApprovalStatus() async {
    return _lio.getApprovalStatus();
  }

  Future<String> getSeaseedConfig(String key)  async {
    return _lio.getSeaseedConfig(key);
  }

  Future<bool> createSeaseedUser() async {
    return _lio.createSeaseedUser();
  }

  Future<User?> getCurrentUser() async {
    _currentUser = await _lio.getUser();
    return _currentUser;
  }

  Future<SeaseedUser?> getCurrentSeaseedUser() async {
    _currentSeaseedUser = await _lio.getSeaseedUser();
    return _currentSeaseedUser;
  }

  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    _otherSeaseedUsers = await _lio.getOtherSeaseedUsers();
    return _otherSeaseedUsers;
  }

  Future<Deposit> createDeposit(int amount) async {
    return _lio.createDeposit(amount);
  }

  Future<Withdrawal> createWithdrawal(
      int amount, String email, String accountNo, String bankCode) async {
    return _lio.createWithdrawal(amount, email, accountNo, bankCode);
  }

  Future<List<Bank>> getBanks() async {
    _banks = await _lio.getBanks();
    return _banks;
  }

  Future<bool> createTransfer(
      String toUserUuid, int amount, String remark) async {
    return _lio.createTransfer(toUserUuid, amount, remark);
  }

  Future<List<Transaction>> getTransactions() async {
    _transactions = await _lio.getTransactions();
    return _transactions;
  }

  Future<bool> processCost() async {
    return _lio.processCost();
  }
}
