import 'package:flutter/material.dart';

import '../model/paying_source.dart';

class PayingComponent extends StatelessWidget {
  final Function(PayingSource) edit;
  const PayingComponent({
    super.key,
    required this.paymentSource,
    required this.edit,
  });

  final PayingSource paymentSource;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: ListTile(
        title: Text(paymentSource.name, style: TextStyle(color: Colors.white)),
        trailing: Text(
          'R\$ ${paymentSource.balance.toStringAsFixed(2)}',
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => edit(paymentSource),
      ),
    );
  }
}
