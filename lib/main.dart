import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',

      ),

      routes: {
        // '/': (ctx) => ProductsOverviewScreen(),
        ProductDetailsScreen.routename: (ctx) => ProductDetailsScreen(),

      },

    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductsOverviewScreen();
  }
}
