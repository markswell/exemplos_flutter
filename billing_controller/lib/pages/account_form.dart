import 'package:billing_controller/components/custom_appbar.dart';
import 'package:billing_controller/model/billing_account.dart';
import 'package:flutter/material.dart';

import '../components/account_form_widget.dart' show AccountFormWidget;

class AccountForm extends StatelessWidget {
  final BillingAccount? account;
  const AccountForm({super.key, this.account});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar.buildAppBarWithoutActions(context),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: AccountFormWidget(account: account, context: context),
        ),
      ),
    );
  }
}
