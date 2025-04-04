import 'package:billing_controller/components/custom_appbar.dart';
import 'package:billing_controller/model/billing_account.dart';
import 'package:flutter/material.dart';

import '../components/account_form_widget.dart' show AccountFormWidget;

class AccountForm extends StatelessWidget {
  final BillingAccount? account;
  final Function() onSaveSuccess;

  const AccountForm({super.key, this.account, required this.onSaveSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.buildAppBarWithoutActions(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: AccountFormWidget(
          account: account,
          onSaveSuccess: () {
            onSaveSuccess();
            Navigator.pop(context);
          },
          context: context,
        ),
      ),
    );
  }
}
