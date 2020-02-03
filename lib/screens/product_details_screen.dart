import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routename = '/productDetails';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

/*
    final loadedProduct = Provider.of<ProductsProvider>(context)
        .items.firstWhere((prod) => prod.id == productId);
*/
    // Here we have uses the same logic as the above one just we created a function in
    // our provider package which provide us Product item filteing with id as an argument
    // We have added the listen to stop listening automatically when the data is changed
    // since we dont need automatic updates in this screen and by default is is set to true
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              // The hero animation takes the same tag id value as the previous one takes
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$' + loadedProduct.price.toString(),
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
