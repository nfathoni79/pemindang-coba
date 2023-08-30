import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/models/seaseed_user.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class TransferViewModel extends FutureViewModel<int> {
  static const String getAdminCostKey = 'getAdminCost';
  static const String createTransferKey = 'createTransfer';

  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  SeaseedUser? receiverUser;
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

  void calculateTotalAmount() {
    if (amountController.text != '') {
      totalAmount = int.parse(amountController.text) + adminCost;
    } else {
      totalAmount = adminCost;
    }

    notifyListeners();
  }
}