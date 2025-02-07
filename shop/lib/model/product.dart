import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toggleFavorite();
      var response = await put(
        Uri.parse(
          '${Constants.USER_FAVORITES_URL}/$userId/$id.json?auth=$token',
        ),
        body: jsonEncode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (erro) {
      _toggleFavorite();
    }
  }
}
