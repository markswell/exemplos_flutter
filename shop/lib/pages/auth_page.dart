import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/custom_appbar.dart';

import '../components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create('Login', context),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 0.5),
                  Color.fromRGBO(255, 188, 117, 0.9)
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 70,
                      ),
                      transform: Matrix4.rotationZ(-5 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        "Minha Loja",
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Anton',
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AuthForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
