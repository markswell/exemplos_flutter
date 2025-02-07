import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/cart.dart';
import 'package:shop/model/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        margin: EdgeInsets.all(15),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Atenção'),
          content: Text(
            'Tem certeza que deseja excluir o produto ${cartItem.name}',
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
      ),
      onDismissed: (_) {
        var items = Provider.of<Cart>(context, listen: false);
        items.removeItem(cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.all(15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text(
                  '${cartItem.price}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          title: Text(cartItem.name),
          subtitle: Text(
              'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
