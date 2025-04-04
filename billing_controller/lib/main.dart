import 'package:billing_controller/pages/payment_source_page.dart';
import 'package:flutter/material.dart';

import 'config/routes_config.dart';
import 'pages/account_form.dart';
import 'pages/accouts_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        RoutesConfig.home: (context) => AccountsPage(),
        RoutesConfig.accountForm: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          return AccountForm(
            account: args?['account'],
            onSaveSuccess: args?['onSaveSuccess'] ?? () {},
          );
        },
        RoutesConfig.paymentSourceForm: (context) => PaymentSourcePage(),
      },
    );
  }
}
