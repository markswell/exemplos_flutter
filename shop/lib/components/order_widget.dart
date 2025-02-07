import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({
    super.key,
    required this.order,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    var products = widget.order.products;
    var style = TextStyle(color: Colors.black);
    var itemsHeight = products.length * 35;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? (itemsHeight + 80) : 90,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
                style: style,
              ),
              trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(Icons.expand_more)),
            ),
            // if (_expanded)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded ? double.parse(itemsHeight.toString()) : 0.0,
              child: Container(
                height: double.parse(itemsHeight.toString()),
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${products[index].name} ',
                        style: style,
                      ),
                      Text(
                        '${products[index].quantity}x R\$ ${products[index].price}',
                        style: style,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
