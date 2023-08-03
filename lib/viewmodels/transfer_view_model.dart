import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class TransferViewModel extends BaseViewModel {
  static const String createTransferKey = 'createTransfer';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  SeaseedUser? receiverUser;

  Future<List<SeaseedUser>> getOtherSeaseedUsers() async {
    return _userService.getOtherSeaseedUsers();
  }

  Future<bool> createTransfer() async {
    setBusyForObject(createTransferKey, true);
    int amount = int.parse(amountController.text);
    String toUserUuid = receiverUser!.userUuid;

    await _userService.createTransfer(toUserUuid, amount, '');
    setBusyForObject(createTransferKey, false);
    return true;
  }
}