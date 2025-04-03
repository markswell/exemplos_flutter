import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/billing_account.dart' show BillingAccount;
import '../model/paying_source.dart';
import '../services/billing_accout_service.dart' show BillingAccountService;
import '../services/paying_source_service.dart';
import '../util/date_time_converter.dart' show DateTimeConverter;

class AccountComponent extends StatefulWidget {
  final BillingAccount account;
  final Function() onUpdate;

  const AccountComponent({
    super.key,
    required this.account,
    required this.onUpdate,
  });

  @override
  State<AccountComponent> createState() => _AccountComponentState();
}

class _AccountComponentState extends State<AccountComponent> {
  late TextEditingController _paymentValueController;
  PayingSource? _selectedPayingSource;
  List<PayingSource> _payingSources = [];

  @override
  void initState() {
    super.initState();
    _paymentValueController = TextEditingController(
      text:
          widget.account.paymentValue?.toString() ??
          widget.account.value.toStringAsFixed(2),
    );
    _loadPayingSources();
  }

  Future<void> _loadPayingSources() async {
    _payingSources = await PayingSourceService().getAllPayingSources();
    if (widget.account.payingSource != null) {
      _selectedPayingSource = _payingSources.firstWhere(
        (source) => source.id == widget.account.payingSource?.id,
        orElse: () => _payingSources.first,
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    _paymentValueController.dispose();
    super.dispose();
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        bool _payed = widget.account.paymentDate != null;
        _paymentValueController.text =
            _payed
                ? widget.account.paymentValue!.toString()
                : widget.account.value.toString();
        return AlertDialog(
          title: Text(_payed ? 'Registrar Pagamento' : 'Editar Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _paymentValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor Pago',
                  prefixText: 'R\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o valor';
                  if (double.tryParse(value) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PayingSource>(
                value: _selectedPayingSource,
                items:
                    _payingSources.map((source) {
                      return DropdownMenuItem<PayingSource>(
                        value: source,
                        child: Text(source.name),
                      );
                    }).toList(),
                onChanged: (source) => _selectedPayingSource = source,
                decoration: const InputDecoration(labelText: 'Fonte Pagadora'),
                validator: (value) {
                  if (value == null) return 'Selecione uma fonte';
                  return null;
                },
              ),
            ],
          ),
          actions: [
            if (widget.account.paymentDate != null) ...[
              TextButton(
                onPressed: () => _markAsUnpaid(),
                child: const Text('Não Pago'),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deletePayment(),
                tooltip: 'Excluir Conta',
              ),
            ],
            if (widget.account.paymentDate == null)
              ElevatedButton(
                onPressed: () => _savePayment(),
                child: const Text('Pagar'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _savePayment() async {
    if (_selectedPayingSource == null) return;
    if (_paymentValueController.text.isEmpty) return;

    try {
      widget.account.paymentDate = DateTime.now();
      widget.account.paymentValue = double.parse(_paymentValueController.text);
      widget.account.payingSource = _selectedPayingSource;

      await BillingAccountService().updateBillingAccount(widget.account);
      widget.onUpdate();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
      );
    }
  }

  Future<void> _markAsUnpaid() async {
    try {
      widget.account.paymentDate = null;
      widget.account.paymentValue = null;
      widget.account.payingSource = null;

      await BillingAccountService().updateBillingAccount(widget.account);
      widget.onUpdate();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar: ${e.toString()}')),
      );
    }
  }

  Future<void> _deletePayment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar Exclusão'),
            content: const Text('Deseja realmente excluir este pagamento?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await BillingAccountService().deleteBillingAccount(widget.account.id!);
        widget.onUpdate();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 10,
      color:
          widget.account.paymentDate != null
              ? Colors.green[300]
              : Colors.red[300],
      child: ListTile(
        title: Text(widget.account.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.account.paymentDate == null) ...[
              Text('Valor: R\$ ${widget.account.value.toStringAsFixed(2)}'),
              Text(
                'Vencimento: ${DateFormat('dd/MM/yyyy').format(widget.account.dueDate)}',
              ),
            ],
            if (widget.account.paymentDate != null) ...[
              Text(
                'Pago em: ${DateTimeConverter.convertDateToString(widget.account.paymentDate!)}',
              ),
              Text(
                'Valor pago: R\$ ${widget.account.paymentValue?.toStringAsFixed(2) ?? ''}',
              ),
              Text('Fonte: ${widget.account.payingSource!.name}'),
            ],
          ],
        ),
        trailing: Icon(
          widget.account.paymentDate != null
              ? Icons.check_circle
              : Icons.cancel,
          color: widget.account.paymentDate != null ? Colors.green : Colors.red,
        ),
        onTap: _showPaymentDialog,
      ),
    );
  }
}
