import 'package:billing_controller/services/billing_accout_service.dart';
import 'package:flutter/material.dart';

import '../model/billing_account.dart';
import '../util/date_time_converter.dart';
import 'date_text_field.dart';

class AccountFormWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();

  final BillingAccount? account;
  final BuildContext context;
  final Function() onSaveSuccess;

  AccountFormWidget({
    this.account,
    required this.context,
    required this.onSaveSuccess,
  });

  @override
  Widget build(BuildContext context) {
    _dateController.text = DateTimeConverter.convertDateToString(
      DateTime.now(),
    );
    if (account != null) {
      _dateController.text = DateTimeConverter.convertDateToString(
        account!.dueDate,
      );
      _valueController.text = account!.value.toStringAsFixed(2);
      _nameController.text = account!.name;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome da conta'),
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite o nome da conta';
              }
              return null;
            },
          ),
          DateTextField(controller: _dateController),
          TextFormField(
            decoration: InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: _valueController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite o valor';
              }
              return null;
            },
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) =>
                            const Center(child: CircularProgressIndicator()),
                  );

                  if (account?.id != null) {
                    account?.name = _nameController.text;
                    account?.dueDate = DateTimeConverter.convertStringToDate(
                      _dateController.text,
                    );
                    account?.value = double.parse(_valueController.text);
                    await BillingAccountService().updateBillingAccount(
                      account!,
                    );
                  } else {
                    final newAccount = BillingAccount(
                      name: _nameController.text,
                      dueDate: DateTimeConverter.convertStringToDate(
                        _dateController.text,
                      ),
                      value: double.parse(_valueController.text),
                    );
                    await BillingAccountService().createBillingAccount(
                      newAccount,
                    );
                  }

                  Navigator.of(context).pop();
                  onSaveSuccess();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao criar conta: ${e.toString()}'),
                    ),
                  );
                }
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
