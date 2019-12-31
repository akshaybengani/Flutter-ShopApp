import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MultiProvider is a type of provider in dart which is used to contain more then 1
    // providers both at the root of the widget tree, Note the child will be using both the providers
    // Its complicated
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          // create: is a new version of builder by the way it is the same as builder which
          // creates the context for his own and takes the constructor of the Provider Class
          // create: (ctx) => ProductsProvider(),

          // Since there is an another way of using changenotifier we can simply use
          // .value at the top in order to remove the extra memory of context
          value: ProductsProvider(),
        ),

        // This is a new provider we just setuped for the cart item and cart processing
        ChangeNotifierProvider.value(
          value: Cart(),
        ),

        // This notifier is for the order provider modal
        ChangeNotifierProvider.value(
          value: Orders(),
        ),

      ],
      // This child is of Multiprovider which contains list of multiple providers.
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primaryColor: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (ctx) => ProductsOverviewScreen(),
          ProductDetailsScreen.routename: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),

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
