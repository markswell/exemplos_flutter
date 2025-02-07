import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/custom_appbar.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/model/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create("Meus Pedidos", context),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Consumer<OrderList>(
                  builder: (ctx, orderList, child) => ListView.builder(
                    itemCount: orderList.itemsCount,
                    itemBuilder: (ctx, index) => SizedBox(
                      child: OrderWidget(order: orderList.items[index]),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
