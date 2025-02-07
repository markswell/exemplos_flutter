import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/product.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  Future<void> _dialogBuilder(
    BuildContext context,
    String title,
    String content,
  ) {
    var textStyle = TextStyle(color: Colors.black);
    return showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text(
              title,
              style: textStyle,
            ),
            content: Text(
              content,
              style: textStyle,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var messengerState = ScaffoldMessenger.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      subtitle: Text(product.description),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    'Atenção',
                    style: TextStyle(color: Colors.black),
                  ),
                  content: Text(
                    'Tem certeza que deseja excluir o produto ${product.name}',
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('Não'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Sim'),
                    ),
                  ],
                ),
              ).then((value) async {
                if (value ?? false) {
                  try {
                    await Provider.of<ProductList>(
                      context,
                      listen: false,
                    ).delete(product);
                  } catch (onErro) {
                    messengerState.showSnackBar(SnackBar(
                        content: Text(
                      onErro.toString(),
                    )));

                    _dialogBuilder(context, 'Error', onErro.toString());
                  }
                }
              }),
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
