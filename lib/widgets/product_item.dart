import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl, title, id;
  // ProductItem({this.id, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 5, color: Colors.green),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routename,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // Since when user press multiple time in short frequency then we need to cancel the
              // running snackbar and then start the previous one.
              Scaffold.of(context).hideCurrentSnackBar();
              // To Show a Snack Bar we have an inbuilt feature with Scaffold to show a snackbar
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added new item to the cart'),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),

          // Consumer is very similar to Provider and it is used with product to optimize
          // here only the IconButton is making the change as such only parts in consumer
          // are going to update nothing else.

          // 1st arg is the context, 2nd is the dynamic data, and 3rd is the child which
          // will not update in any case by the way its too advanced for tiny optimization.
          trailing: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavoriteStatus(context);
              },
            ),
          ),
          backgroundColor: Colors.black38,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
