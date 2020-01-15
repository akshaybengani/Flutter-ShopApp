import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // Here we used the Provider class to collect products data using the ProductsProvider
    // Method we setuped at the main so it will check for the Change Notifier whereever
    // It finds and then call the ProductsProvider constructor with the context
    // .items is the getter function we created in the ProductsProvider class
    // As such the productsData is containing the list of products sent from the getter method.
    final products = Provider.of<ProductsProvider>(context, listen: true);
    final productsData = showFavs ? products.favitems : products.items;
    // The listen value is defult set to true but I have set it for info, to note that
    // this needs to update whenever the data changes.

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: productsData.length,
      // SilverGridDelegateWithFixedCrossAxisCount is a fix type of GridView which scales
      // the size of the view container and not increasing the number of containers.
      // So in case when we need to setup exact same number of containers at any screen size we use this.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // crossAxisCount takes the number of containers in horizontal axix
        crossAxisCount: 2,
        // The Aspect Ratio defines the aspect size of a single container
        childAspectRatio: 3 / 2,
        // its like horizontal padding and it differs one container from another
        crossAxisSpacing: 10,
        // its like horizontal padding and it differs one container from another
        mainAxisSpacing: 10,
      ),

      // This is our builder method we use to build the griditem we have provided the
      // layout widget and passed index value in it, it works like a foreach
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: productsData[index],
        child: ProductItem(
          // id: productsData[index].id,
          // imageUrl: productsData[index].imageUrl,
          // title: productsData[index].title,
        ),
      ),
    );
  }
}
