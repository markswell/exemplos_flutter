import 'package:billing_controller/pages/payment_source_form.dart';
import 'package:billing_controller/util/date_time_util.dart';
import 'package:flutter/material.dart';

import '../services/paying_source_service.dart';

class CustomAppbar {
  static AppBar buildAppBar(BuildContext context, function(DateTime date)) {
    return AppBar(
      title: Text('Billing Controller', style: TextStyle(color: Colors.white)),
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).primaryColor,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.calendar_month),
          onPressed: () => _showCustomMonthYearPicker(context, function),
        ),
        IconButton(
          icon: Icon(Icons.monetization_on),
          onPressed: () async {
            try {
              var listPayingSource =
                  await PaymentSourceService().getAllPayingSources();

              if (listPayingSource.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Nenhuma fonte pagadora cadastrada'),
                      content: Text('Cadastre uma fonte pagadora primeiro.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PaymentSourceForm(
                                      onSave: () => Navigator.pop(context),
                                    ),
                              ),
                            );
                          },
                          child: Text('Cadastrar'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                double totalValue = listPayingSource.fold(
                  0.0,
                  (sum, element) => sum + (element.balance),
                );

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Saldo Total R\$${totalValue.toStringAsFixed(2)}',
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listPayingSource.length,
                          itemBuilder:
                              (context, index) => Card(
                                color: Theme.of(context).colorScheme.primary,
                                child: ListTile(
                                  title: Text(
                                    listPayingSource[index].name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'R\$${listPayingSource[index].balance.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Fechar'),
                        ),
                      ],
                    );
                  },
                );
              }
            } catch (e) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Erro'),
                      content: Text('Falha ao carregar fontes pagadoras: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            }
          },
        ),
      ],
    );
  }

  static AppBar buildAppBarWithoutActions(BuildContext context) {
    return AppBar(
      title: Text('Billing Controller', style: TextStyle(color: Colors.white)),
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [],
    );
  }
}

_showCustomMonthYearPicker(
  BuildContext context,
  Function(DateTime date) callback,
) {
  final List<String> months = DateTimeUtil.getMonths();

  final int currentYear = DateTime.now().year;
  int? selectedYear = currentYear;
  int? selectedMonth;

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<int>(
                  value: selectedYear,
                  hint: const Text("Selecione o ano"),
                  items: List.generate(201, (index) {
                    int year = currentYear - 100 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (year) {
                    setState(() => selectedYear = year);
                  },
                ),
              ),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = selectedMonth == month;
                    return InkWell(
                      onTap:
                          selectedYear == null
                              ? null
                              : () {
                                setState(() => selectedMonth = month);
                              },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[100] : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            months[index],
                            style: TextStyle(
                              color: isSelected ? Colors.blue : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed:
                      (selectedYear != null && selectedMonth != null)
                          ? () {
                            final selectedDate = DateTime(
                              selectedYear!,
                              selectedMonth!,
                              1,
                            );
                            Navigator.pop(context);
                            callback(
                              selectedDate,
                            ); // Chama a função callback com a data selecionada
                          }
                          : null,
                  child: const Text("Confirmar"),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
