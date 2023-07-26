import 'package:flutter/material.dart';
import 'package:pemindang_coba/utils/my_utils.dart';
import 'package:pemindang_coba/viewmodels/login_view_model.dart';
import 'package:pemindang_coba/views/main_view.dart';
import 'package:pemindang_coba/views/register_view.dart';
import 'package:pemindang_coba/views/widgets/my_button.dart';
import 'package:pemindang_coba/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
        ),
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Image.asset('assets/images/perindo_pemindang.png'),
                ),
                Card(
                  elevation: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Masuk ke akun Anda',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        _buildForm(viewModel),
                        const SizedBox(height: 16),
                        MyButton(
                          text: 'Masuk',
                          backgroundColor: Colors.orange.shade300,
                          onPressed: () => _onPressedLogin(context, viewModel),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun?'),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterView())),
                              child: const Text('Daftar'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Lupa password?'),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Reset password'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();

  Widget _buildForm(LoginViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          MyTextFormField(
            controller: viewModel.usernameController,
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person_outline),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
          const SizedBox(height: 16),
          MyTextFormField(
            controller: viewModel.passwordController,
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: (value) => viewModel.noEmptyValidator(value),
          ),
        ],
      ),
    );
  }

  void _onPressedLogin(BuildContext context, LoginViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);
    String? message = await viewModel.login();

    if (context.mounted) {
      Navigator.pop(context);

      if (message != null) {
        MyUtils.showErrorDialog(
          context,
          message: message,
        );

        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainView(),
        ),
        (route) => false,
      );
    }
  }
}
