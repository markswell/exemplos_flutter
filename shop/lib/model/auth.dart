import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exception/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiredDate;
  Timer? _logaoutTimer;

  bool get isAuth {
    final isValide = _expiredDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValide;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyAtn7fHN7tpgmbWgDhvZDsb48v46STRUQ0';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    var body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiredDate': _expiredDate!.toIso8601String(),
      });
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiredDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['eamil'];
    _userId = userData['userId'];
    _expiredDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiredDate = null;
    Store.remove('userData').then(
      (value) => notifyListeners(),
    );
  }

  void _clearLogaoutTimer() {
    _logaoutTimer?.cancel();
    _logaoutTimer = null;
  }

  void _autoLogout() {
    _clearLogaoutTimer();
    final timeToLogout = _expiredDate?.difference(DateTime.now()).inSeconds;
    _logaoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}
