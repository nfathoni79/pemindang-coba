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

  @override
  Future<int> futureToRun() {
    return getAdminCost();
  }

  Future<int> getAdminCost() async {
    setBusyForObject(getAdminCostKey, true);
    String costText = await _userService.getSeaseedConfig('admin_cost');
    setBusyForObject(getAdminCostKey, false);
    return int.parse(costText);
  }

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    int amount = int.parse(amountController.text);

    deposit = await _userService.createDeposit(amount);
    setBusyForObject(createDepositKey, false);
    return deposit;
  }
}