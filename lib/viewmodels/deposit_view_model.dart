import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/deposit.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class DepositViewModel extends FutureViewModel<int> {
  static const String getAdminCostKey = 'getAdminCost';
  static const String createDepositKey = 'createDeposit';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Deposit? deposit;
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

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    deposit = await _userService.createDeposit(totalAmount);
    setBusyForObject(createDepositKey, false);
    return deposit;
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