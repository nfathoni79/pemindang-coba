import 'package:flutter/material.dart';
import 'package:pemindang_coba/viewmodels/pending_view_model.dart';
import 'package:pemindang_coba/views/login_view.dart';
import 'package:pemindang_coba/views/main_view.dart';
import 'package:pemindang_coba/views/widgets/my_button.dart';
import 'package:stacked/stacked.dart';

class PendingView extends StackedView<PendingViewModel> {
  const PendingView({super.key});

  @override
  Widget builder(
      BuildContext context, PendingViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Perindo Bisnis'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: viewModel.dataReady
                  ? Text(viewModel.getApprovalText(viewModel.data!))
                  : const Center(child: CircularProgressIndicator()),
            ),
            MyButton(
              text: 'Cek Status',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.blue.shade50,
              onPressed: () => _onPressedCheckStatus(context, viewModel),
            ),
            MyButton(
              text: 'Keluar',
              backgroundColor: Colors.red,
              foregroundColor: Colors.red.shade50,
              onPressed: () => _onPressedLogout(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PendingViewModel viewModelBuilder(BuildContext context) => PendingViewModel();

  void _onPressedCheckStatus(
      BuildContext context, PendingViewModel viewModel) async {
    int status = await viewModel.getApprovalStatus();
    viewModel.data = status;

    if (context.mounted && status > 0) {
      viewModel.setUserApproved();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const MainView(),
          ),
          (route) => false,
        );
      }
    }
  }

  void _onPressedLogout(
      BuildContext context, PendingViewModel viewModel) async {
    viewModel.logout();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
  }
}
