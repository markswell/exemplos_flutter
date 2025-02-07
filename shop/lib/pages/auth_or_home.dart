import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';

class AuthOrHome extends StatelessWidget {
  const AuthOrHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return Center(
            child: Text(
              'Ocorreu um erros',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          );
        } else {
          return auth.isAuth ? ProductOverView() : AuthPage();
        }
      },
    );
  }
}
