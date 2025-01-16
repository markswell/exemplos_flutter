import 'package:flutter/material.dart';

class ApplicationAppBar {
  static AppBar createAppBar(String title, BuildContext context) {
    Color color = Colors.white;
    return AppBar(
        iconTheme: IconThemeData(color: color),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: color,
          ),
        ));
  }
}
