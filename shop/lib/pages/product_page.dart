import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_appbar.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/app_drawer.dart';
import '../components/product_item.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductList>(context, listen: false).loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    var productList = Provider.of<ProductList>(context);
    var appBar = CustomAppBar.create('Gerenciar produtos', context);
    appBar.actions!.add(IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(
          AppRoutes.PRODUCT_FORM,
        );
      },
      icon: Icon(Icons.add),
    ));

    return Scaffold(
      appBar: appBar,
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productList.items.length,
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  ProductItem(
                    product: productList.items[index],
                  ),
                  Divider()
                ],
              );
            },
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
