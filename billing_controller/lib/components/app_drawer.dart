import 'package:flutter/material.dart';

import '../config/routes_config.dart';

class AppDrawer extends StatefulWidget {
  final Function? onSaveSuccess;
  const AppDrawer({super.key, required this.onSaveSuccess});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text('Cadastros', style: TextStyle(color: Colors.white)),
            ),
          ),
          ListTile(
            title: const Text('Fonte pagadora'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, RoutesConfig.paymentSourceForm);
            },
          ),
          ListTile(
            title: const Text('Conta'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(
                context,
                RoutesConfig.accountForm,
                arguments: {'onSaveSuccess': widget.onSaveSuccess},
              );
            },
          ),
        ],
      ),
    );
  }
}
