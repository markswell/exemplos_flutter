import 'package:billing_controller/model/paying_source.dart';
import 'package:flutter/material.dart';

import '../components/custom_appbar.dart';
import '../components/paying_component.dart';
import '../services/paying_source_service.dart';
import 'payment_source_form.dart';

class PaymentSourcePage extends StatefulWidget {
  const PaymentSourcePage({super.key});

  @override
  State<PaymentSourcePage> createState() => _PaymentSourcePageState();
}

class _PaymentSourcePageState extends State<PaymentSourcePage> {
  final List<PayingSource> paymentSources = [];
  bool isAdding = false;
  PayingSource? payingSource = null;

  changeIsAdding() {
    setState(() {
      isAdding = !isAdding;
    });
  }

  editPayingSource(PayingSource paymentSource) {
    setState(() {
      isAdding = true;
      this.payingSource = paymentSource;
    });
  }

  @override
  Widget build(BuildContext context) {
    var addActionButton = IconButton(
      icon: const Icon(Icons.add),
      onPressed: changeIsAdding,
    );
    var appBar = CustomAppbar.buildAppBarWithoutActions(context);
    appBar.actions?.add(addActionButton);

    return FutureBuilder(
      future: getData(paymentSources),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: appBar,
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                if (isAdding)
                  PaymentSourceForm(
                    onSave: changeIsAdding,
                    paymentSource: payingSource,
                  ),
                if (!isAdding && paymentSources.length > 0)
                  Expanded(
                    child: ListView.builder(
                      itemCount: paymentSources.length,
                      itemBuilder:
                          (context, index) => PayingComponent(
                            paymentSource: paymentSources[index],
                            edit: editPayingSource,
                          ),
                    ),
                  ),
                if (!isAdding && paymentSources.length <= 0)
                  Expanded(
                    child: Center(
                      child: Text('Não há fontes pagadoras a serem exibidas'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

getData(List<PayingSource> paymentSources) async {
  var list = await PaymentSourceService().getAllPayingSources();
  paymentSources.clear();
  paymentSources.addAll(list);
}
