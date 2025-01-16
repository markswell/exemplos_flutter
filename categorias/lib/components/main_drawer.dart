import 'package:flutter/material.dart';

import '../utils/app_routs.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget _createItem(IconData icon, String lable, Function onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        lable,
        style: TextStyle(
            fontFamily: 'RobotoCondensed',
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      onTap: () => onTap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              color: Theme.of(context).colorScheme.secondary,
              child: Text(
                'Vamos cozinhar?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            _createItem(
              Icons.restaurant,
              'Refeições',
              () => Navigator.of(context).pushReplacementNamed(AppRoutes.HOME),
            ),
            SizedBox(
              height: 20,
            ),
            _createItem(
              Icons.settings,
              'Configurações',
              () => Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.SETTINGS),
            ),
          ],
        ),
      ),
    );
  }
}
