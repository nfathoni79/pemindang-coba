import 'package:flutter/material.dart';
import 'package:pemindang_coba/app/locator.dart';
import 'package:pemindang_coba/services/user_service.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  final _userService = locator<UserService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String? noEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harap diisi';
    }

    return null;
  }

  Future<String?> login() async {
    setBusy(true);

    String username = usernameController.text;
    String password = passwordController.text;

    try {
      await _userService.login(username, password);
      setBusy(false);
      return null;
    } catch (e) {
      setBusy(false);
      return e.toString();
    }
  }
}