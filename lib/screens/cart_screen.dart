import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cartscreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.totalAmount.toString(),
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'Order Now',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    // Order Button
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cartProducts: cart.items.values.toList(),
                          total: cart.totalAmount);
                      cart.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          cart.itemcount == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'You have no items in your Cart.',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Please add items from shop.',
                      style: TextStyle(
                          fontSize: 25, color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 20),
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      color: Colors.purple,
                      child: Text('Shop Now', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold )),
                    )
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) => ci.CartItem(
                      id: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                      title: cart.items.values.toList()[index].title,
                    ),
                    itemCount: cart.itemcount,
                  ),
                )
        ],
      ),
    );
  }
}
