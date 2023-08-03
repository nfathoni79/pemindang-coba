import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/deposit.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class DepositViewModel extends BaseViewModel {
  static const String createDepositKey = 'createDeposit';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  Deposit? deposit;

  Future<Deposit?> createDeposit() async {
    setBusyForObject(createDepositKey, true);
    int amount = int.parse(amountController.text);

    deposit = await _userService.createDeposit(amount);
    setBusyForObject(createDepositKey, false);
    return deposit;
  }
}