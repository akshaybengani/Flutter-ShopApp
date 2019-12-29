import 'package:flutter/material.dart';
import 'package:shop_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
      ),

      // This widget is extracted because we will call the providerpackage data and since
      // That will rebuild the context and we dont need to build Scaffold again for a change
      // in products as such we needed to extract the GridView in seperate widget.
      body: ProductsGrid(),
    );
  }
}
