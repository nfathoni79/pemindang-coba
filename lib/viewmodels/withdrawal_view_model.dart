import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/bank.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class WithdrawalViewModel extends FutureViewModel<int> {
  static const String getAdminCostKey = 'getAdminCost';
  static const String createWithdrawalKey = 'createWithdrawal';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final emailController = TextEditingController();
  final accountNoController = TextEditingController();
  Bank? bank;
  int adminCost = 0;
  int totalAmount = 0;

  @override
  Future<int> futureToRun() {
    return getAdminCost();
  }

  Future<int> getAdminCost() async {
    setBusyForObject(getAdminCostKey, true);
    String costText = await _userService.getSeaseedConfig('admin_cost');
    adminCost = int.parse(costText);
    totalAmount = adminCost;
    setBusyForObject(getAdminCostKey, false);

    return adminCost;
  }

  Future<List<Bank>> getBanks() async {
    return _userService.getBanks();
  }

  Future<bool> createWithdrawal() async {
    setBusyForObject(createWithdrawalKey, true);
    int amount = int.parse(amountController.text);
    String email = emailController.text;
    String accountNo = accountNoController.text;
    String bankCode = bank!.code;

    await _userService.createWithdrawal(amount, email, accountNo, bankCode);
    setBusyForObject(createWithdrawalKey, false);
    return true;
  }

  void calculateTotalAmount() {
    if (amountController.text != '') {
      totalAmount = int.parse(amountController.text) + adminCost;
    } else {
      totalAmount = adminCost;
    }

    notifyListeners();
  }
}