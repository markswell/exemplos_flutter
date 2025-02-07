import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/model/cart.dart';
import '../model/auth.dart';
import '../model/product.dart';
import '../utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context);
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavorite(
                    auth.token ?? '',
                    auth.userId ?? '',
                  );
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                )),
          ),
          trailing: GestureDetector(
            onLongPress: () {
              cart.removeItem(product.id);
            },
            // onDoubleTap: () => cart.removeItem(product.id),
            child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Produto adicionado ${product.name}',
                      ),
                      duration: Duration(milliseconds: 1500),
                      action: SnackBarAction(
                        label: 'DESFAZER',
                        onPressed: () {
                          cart.removeASingleItem(product.id);
                        },
                      ),
                    ),
                  );
                  cart.add(product);
                },
                icon: Icon(
                  cart.items.containsKey(product.id)
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                )),
          ),
          backgroundColor: Colors.black38,
          title: Text(product.name),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  AssetImage('lib/assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
