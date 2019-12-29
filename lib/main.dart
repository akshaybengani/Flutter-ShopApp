import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      
      // create: is a new version of builder by the way it is the same as builder which
      // creates the context for his own and takes the constructor of the Provider Class
      // create: (ctx) => ProductsProvider(),

      // Since there is an another way of using changenotifier we can simply use
      // .value at the top in order to remove the extra memory of context 
      value: ProductsProvider(),

      // ...
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          // '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailsScreen.routename: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductsOverviewScreen();
  }
}
