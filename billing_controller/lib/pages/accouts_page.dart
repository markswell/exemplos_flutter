import 'package:billing_controller/services/ordem_servie.dart';
import 'package:flutter/material.dart';
import 'package:billing_controller/util/date_time_util.dart';
import 'package:billing_controller/model/billing_account.dart';
import 'package:billing_controller/services/billing_accout_service.dart';

import '../components/app_drawer.dart';
import '../components/custom_appbar.dart';
import '../components/billing_account_component.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<BillingAccount> _accounts = [];
  DateTime selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() => _isLoading = true);
    try {
      final monthBoundaryDates = DateTimeUtil.getMonthBoundaryDates(
        selectedDate,
      );
      final selectedAccounts = await BillingAccountService()
          .getAccountsByDateRange(
            monthBoundaryDates['firstDay']!,
            monthBoundaryDates['lastDay']!,
          );
      setState(() => _accounts = selectedAccounts);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar contas: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void updateMonthList(DateTime date) {
    setState(() => selectedDate = date);
    _loadAccounts();
  }

  Future<void> _updateOrderInDatabase() async {
    for (int i = 0; i < _accounts.length; i++) {
      _accounts[i].order = await OrdemService().getNewOrdem();
      await BillingAccountService().updateBillingAccount(_accounts[i]);
    }
  }

  Future<void> _handleReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final BillingAccount item = _accounts.removeAt(oldIndex);
    setState(() {
      _accounts.insert(newIndex, item);
    });

    await _updateOrderInDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final _month = DateTimeUtil.getMonths()[selectedDate.month - 1];
    final _year = selectedDate.year;
    final _period = Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Text(
        'Periodo: ${_month} de ${_year}',
        style: TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_accounts.isEmpty) {
      return Scaffold(
        appBar: CustomAppbar.buildAppBar(context, updateMonthList),
        drawer: AppDrawer(onSaveSuccess: _loadAccounts),
        body: Column(
          children: [
            _period,
            Expanded(
              child: Center(child: Text('Não há contas a serem exibidas')),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppbar.buildAppBar(context, updateMonthList),
      drawer: AppDrawer(onSaveSuccess: _loadAccounts),
      body: Column(
        children: [
          _period,
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _accounts.length,
              itemBuilder:
                  (context, index) => AccountComponent(
                    key: ValueKey(_accounts[index].id),
                    account: _accounts[index],
                    onUpdate: _loadAccounts,
                  ),
              onReorder: _handleReorder,
            ),
          ),
        ],
      ),
    );
  }
}
