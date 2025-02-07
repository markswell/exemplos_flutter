import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/model/cart.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/badgee.dart';
import '../components/product_grid.dart';

enum FilterSelected {
  Favorite,
  All,
}

class ProductOverView extends StatefulWidget {
  const ProductOverView({super.key});

  @override
  State<ProductOverView> createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProduct()
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    // final Cart cart = Provider.of<Cart>(context);

    AppBar appBar = AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      title: Text(
        'Minha Loja',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white,
            ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: FilterSelected.All,
              child: Text("Todos"),
            ),
            PopupMenuItem(
              value: FilterSelected.Favorite,
              child: Text('Favoritos'),
            ),
          ],
          onSelected: (FilterSelected selectedValue) {
            switch (selectedValue) {
              case FilterSelected.All:
                setState(() {
                  _showFavoriteOnly = false;
                });
                break;
              case FilterSelected.Favorite:
                setState(() {
                  _showFavoriteOnly = true;
                });
                break;
            }
          },
        ),
        Consumer<Cart>(
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.CART,
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
          builder: (context, cart, child) => Badgee(
            color: Colors.white,
            value: cart.itemsCount.toString(),
            child: child!,
          ),
        ),
      ],
    );

    return SafeArea(
      child: _isLoading
          ? Scaffold(
              appBar: appBar,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: appBar,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ProductGrid(
                    showFilteredOnly: _showFavoriteOnly,
                  ),
                ),
              ),
              drawer: AppDrawer(),
            ),
    );
  }
}
