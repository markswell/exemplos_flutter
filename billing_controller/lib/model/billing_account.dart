import 'package:billing_controller/model/paying_source.dart';

class BillingAccount {
  int? id;
  String name;
  double value;
  DateTime dueDate;
  DateTime? paymentDate;
  double? paymentValue;
  PayingSource? payingSource;

  BillingAccount({
    this.id,
    required this.name,
    required this.value,
    required this.dueDate,
    this.paymentDate,
    this.paymentValue,
    this.payingSource,
  });
}
