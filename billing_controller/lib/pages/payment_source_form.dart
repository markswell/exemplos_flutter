import 'package:billing_controller/model/paying_source.dart';
import 'package:billing_controller/services/paying_source_service.dart';
import 'package:flutter/material.dart';

class PaymentSourceForm extends StatelessWidget {
  final PayingSource? paymentSource;
  final Function() onSave;

  const PaymentSourceForm({
    super.key,
    this.paymentSource,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final balanceController = TextEditingController();

    if (paymentSource != null) {
      nameController.text = paymentSource!.name;
      balanceController.text = paymentSource!.balance.toStringAsFixed(2);
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome da fonte pagadora'),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite o nome da conta';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Saldo da fonte pagadora',
              prefixText: 'R\$ ',
            ),
            controller: balanceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite o saldo da fonte pagadora';
              }
              return null;
            },
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );

                if (paymentSource != null) {
                  final toSave = PayingSource(
                    id: paymentSource!.id,
                    name: nameController.text,
                    balance: double.parse(balanceController.text),
                  );

                  await PaymentSourceService().updatePayingSource(toSave);
                } else {
                  final toSave = PayingSource(
                    name: nameController.text,
                    balance: double.parse(balanceController.text),
                  );

                  await PaymentSourceService().createPayingSource(toSave);
                }

                this.onSave();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Salvar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
