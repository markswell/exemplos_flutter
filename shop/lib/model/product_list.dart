import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/exception/http_exception.dart';
import 'package:shop/model/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Product> _items = [];

  final _baseUrl = Constants.PRODUCT_BASE_URL;

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => [..._items.where((i) => i.isFavorite)];

  Future<void> loadProduct() async {
    final response = await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data.isEmpty) return;

    final favoriteResponse = await http.get(Uri.parse(
      '${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token',
    ));

    Map<String, dynamic> favoriteData = favoriteResponse.body == 'null'
        ? {}
        : jsonDecode(favoriteResponse.body);

    data.forEach((productId, productData) {
      var notEmpty = _items.where((p) => p.id == productId).isNotEmpty;
      if (notEmpty) return;
      _items.add(
        Product(
          id: productId,
          name: productData['name'].toString(),
          description: productData['description'].toString(),
          price: (productData['price'] as double),
          imageUrl: productData['imageUrl'].toString(),
          isFavorite: favoriteData[productId] ?? false,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    var response = await http.post(
      Uri.parse('$_baseUrl.json?auth=$_token'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      }),
    );

    var id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> delete(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index < 0) return;

    final productDeleted = _items[index];
    _items.removeWhere((p) => p.id == product.id);

    var response = await http
        .delete(Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'));
    if (response.statusCode > 400) {
      _items.add(productDeleted);
      notifyListeners();
      throw HttpException(
        statusCode: response.statusCode,
        message: 'Erro ao deletar o produto ${product.name}',
      );
    }
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    var product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      price: data['preco'] as double,
      imageUrl: data['urlImage'] as String,
      description: data['description'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  // bool _showFavorityOnly = false;

  // void showFavoriteOnly() {
  //   _showFavorityOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorityOnly = false;
  //   notifyListeners();
  // }

  // List<Product> get items {
  //   if (_showFavorityOnly) {
  //     return [..._items.where((i) => i.isFavorite)];
  //   }
  //   return [..._items];
  // }
}
