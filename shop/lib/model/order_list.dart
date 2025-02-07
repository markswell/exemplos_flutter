import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'cart.dart';
import 'cart_item.dart';
import 'order.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  final String _auth;
  final String _userId;
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  OrderList([this._auth = '', this._userId = '', this._items = const []]);

  Future<void> add(final Cart cart) async {
    final date = DateTime.now();
    final items = cart.items;
    final totalAmout = cart.totalAmout;

    var response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_auth'),
      body: jsonEncode({
        'total': cart.totalAmout,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'productId': cartItem.productId,
                  'name': cartItem.name,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    var id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: totalAmout,
        products: items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    var response = await http.get(
        Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_auth'));
    var data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (i) => CartItem(
                  id: i['productId'],
                  productId: i['productId'],
                  name: i['name'],
                  price: i['price'],
                  quantity: i['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _items = items.reversed.toList();
    notifyListeners();
  }
}
