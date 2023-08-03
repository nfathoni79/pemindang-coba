import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/bank.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class WithdrawalViewModel extends BaseViewModel {
  static const String createWithdrawalKey = 'createWithdrawal';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final emailController = TextEditingController();
  final accountNoController = TextEditingController();
  Bank? bank;

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
}