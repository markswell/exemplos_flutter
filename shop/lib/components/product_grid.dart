import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../model/product_list.dart';
import 'product_grid_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFilteredOnly;
  const ProductGrid({
    super.key,
    required this.showFilteredOnly,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    List<Product> products =
        showFilteredOnly ? provider.favoriteItems : provider.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductGridItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
