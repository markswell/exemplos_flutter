import 'package:flutter/material.dart';
import 'package:shop/model/product.dart';

class ProductDeteil extends StatelessWidget {
  const ProductDeteil({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            expandedHeight: 300,
            elevation: 0,
            title: Text(
              product.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            pinned: true,
            snap: true,
            floating: true,
            stretch: true,
            // flexibleSpace: FlexibleSpaceBar(
            //   title: Text(
            //     product.name,
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   background: Hero(
            //     tag: product.id,
            //     child: SizedBox(
            //       height: 300,
            //       child: Image.network(
            //         product.imageUrl,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
            flexibleSpace: FlexibleSpaceBar.createSettings(
              currentExtent: 0.0,
              child: AppBar(
                flexibleSpace: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: product.id,
                      child: SizedBox(
                        height: 300,
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0, 0.5),
                          end: Alignment(0, 0),
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0),
                            Color.fromRGBO(0, 0, 0, 0.6),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  'R\$ ${product.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Text(
                      product.description,
                      style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1000,
                ),
                Text(
                  'Fim',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
