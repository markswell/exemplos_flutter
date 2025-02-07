import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/components/custom_appbar.dart';
import 'package:shop/model/order_list.dart';

import '../model/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: CustomAppBar.create('Carrinho', context),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(25),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Chip(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5,
                        ),
                        label: Text(
                          'R\$ ${cart.totalAmout.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      Spacer(),
                      CartButtom(cart: cart),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (contex, cartItem, child) => ListView.builder(
                      itemCount: cart.itemsCount,
                      itemBuilder: (ctx, index) {
                        final item = items[index];
                        return CartItemWidget(cartItem: item);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartButtom extends StatefulWidget {
  const CartButtom({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<CartButtom> createState() => _CartButtomState();
}

class _CartButtomState extends State<CartButtom> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : TextButton(
            onPressed: widget.cart.itemsCount > 0
                ? () async {
                    setState(() => isLoading = true);
                    await Provider.of<OrderList>(
                      context,
                      listen: false,
                    ).add(widget.cart);
                    widget.cart.clear();
                    setState(() => isLoading = false);
                  }
                : null,
            child: Text('Compar'),
          );
  }
}
