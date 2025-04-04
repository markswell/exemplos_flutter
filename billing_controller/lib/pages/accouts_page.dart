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
  List<BillingAccount> accounts = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      Map monthBoundaryDates = DateTimeUtil.getMonthBoundaryDates(selectedDate);
      final selectedAccounts = await BillingAccountService()
          .getAccountsByDateRange(
            monthBoundaryDates['firstDay']!,
            monthBoundaryDates['lastDay']!,
          );
      setState(() {
        accounts = selectedAccounts;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar contas: ${e.toString()}')),
      );
    }
  }

  void updateMonthList(DateTime date) {
    setState(() => selectedDate = date);
    _loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    var _month = DateTimeUtil.getMonths()[selectedDate.month - 1];
    var _year = selectedDate.year;
    var _period = Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Text(
        'Periodo: ${_month} de ${_year}',
        style: TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );

    return FutureBuilder(
      future: getData(this.accounts, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (accounts.isEmpty) {
          return Scaffold(
            appBar: CustomAppbar.buildAppBar(context, updateMonthList),
            drawer: AppDrawer(onSaveSuccess: () => setState(() {})),
            body: Column(
              children: [
                _period,
                Expanded(
                  child: Center(child: Text('Não há contas a serem exibidas')),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: CustomAppbar.buildAppBar(context, this.updateMonthList),
            drawer: AppDrawer(onSaveSuccess: () => setState(() {})),
            body: Column(
              children: [
                _period,
                Expanded(
                  child: ListView.builder(
                    itemCount: accounts.length,
                    itemBuilder:
                        (context, index) => AccountComponent(
                          account: accounts[index],
                          onUpdate: () => setState(() {}),
                        ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

getData(List<BillingAccount> accounts, DateTime date) async {
  Map monthBoundaryDates = DateTimeUtil.getMonthBoundaryDates(date);
  BillingAccountService billingAccountService = BillingAccountService();
  var selecttedAccounts = await billingAccountService.getAccountsByDateRange(
    monthBoundaryDates['firstDay']!,
    monthBoundaryDates['lastDay']!,
  );
  accounts.clear();
  accounts.addAll(selecttedAccounts);
}
