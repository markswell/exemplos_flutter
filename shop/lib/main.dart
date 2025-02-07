import 'package:flutter/material.dart';
import 'package:shop/model/cart.dart';
import 'package:shop/model/order_list.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/pages/auth_or_home.dart';
import 'package:shop/pages/product_detail.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/product_page.dart';
import 'package:shop/utils/custom_route.dart';

import './utils/app_routes.dart';
import 'package:provider/provider.dart';
import './pages/orders_page.dart';

import 'model/auth.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previous) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update: (ctx, auth, previus) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previus?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.copyWith(
          textTheme: TextTheme(bodyLarge: TextStyle(fontFamily: 'Lato')),
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            TargetPlatform.android: CustomPageTransitionsBuilder(),
          }),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (_) => AuthOrHome(),
          AppRoutes.CART: (_) => CartPage(),
          AppRoutes.PRODUCT_DETAIL: (_) => ProductDeteil(),
          AppRoutes.ORDERS: (_) => OrdersPage(),
          AppRoutes.PRODUCTS: (_) => ProductPage(),
          AppRoutes.PRODUCT_FORM: (_) => ProductFormPage(),
        },
        // home: ProductOverView(),
      ),
    );
  }
}
