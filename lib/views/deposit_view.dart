import 'package:flutter/material.dart';
import 'package:pemindang_coba/models/deposit.dart';
import 'package:pemindang_coba/utils/my_utils.dart';
import 'package:pemindang_coba/viewmodels/deposit_view_model.dart';
import 'package:pemindang_coba/views/widgets/my_button.dart';
import 'package:pemindang_coba/views/widgets/my_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DepositView extends StackedView<DepositViewModel> {
  const DepositView({super.key});

  @override
  Widget builder(
      BuildContext context, DepositViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Setor'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Form(
                      key: viewModel.formKey,
                      child: MyTextFormField(
                        controller: viewModel.amountController,
                        labelText: 'Nominal Setor',
                        suffixText: 'IDR',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: (value) => MyUtils.noEmptyValidator(value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya layanan'),
                        Text('0 IDR'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MyButton(
              text: 'Setor',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.blue.shade50,
              onPressed: () => _onPressedDeposit(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DepositViewModel viewModelBuilder(BuildContext context) => DepositViewModel();

  void _onPressedDeposit(
      BuildContext context, DepositViewModel viewModel) async {
    if (!viewModel.formKey.currentState!.validate()) return;

    MyUtils.showLoading(context);

    try {
      Deposit? deposit = await viewModel.createDeposit();
      if (context.mounted) {
        Navigator.pop(context);
        _showDepositSuccessDialog(context, deposit!);
      }
    } catch (e) {
      Navigator.pop(context);
      MyUtils.showErrorDialog(context, message: e.toString());
    }
  }

  Future _showDepositSuccessDialog(
      BuildContext context, Deposit deposit) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menunggu Pembayaran'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lakukan pembayaran pada tautan berikut:'),
            InkWell(
              onTap: () async =>
                  await launchUrl(Uri.parse(deposit.paymentLink)),
              child: Text(
                deposit.paymentLink,
                style: TextStyle(
                  color: Colors.blue.shade800,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue.shade800,
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Saya sudah melakukan pembayaran'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
