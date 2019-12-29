import 'package:flutter/material.dart';

import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  //productsContainer.showFavorites();
                  _showOnlyFavorites = true;
                } else {
                  //productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),

      // This widget is extracted because we will call the providerpackage data and since
      // That will rebuild the context and we dont need to build Scaffold again for a change
      // in products as such we needed to extract the GridView in seperate widget.
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
