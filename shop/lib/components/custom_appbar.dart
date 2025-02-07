import 'package:flutter/material.dart';

class CustomAppBar {
  static AppBar create(String title, BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
            ),
      ),
      actions: [],
      backgroundColor: Theme.of(context).colorScheme.primary,

      // leadingWidth: MediaQuery.of(context).size.width,
    );
  }
}
