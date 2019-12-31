import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.title,
    this.quantity,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    
    // Dismissible is a widget which provide us the sliding feature in a layout
    // like we implemented here to delete a cart item by sliding right to left
    return Dismissible(
      // Since it needs a direction because we have 4 directions to dismiss needed to choose something
      direction: DismissDirection.endToStart,
      // onDismissed takes a function and we passed our Annonymous one to delete the item from cart
      onDismissed: (direction) {
        // This takes an argument direction because we can perform multiple onDismissed based on the direction user did dismissed
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      // So sometimes we need to implement a confirmation to alert user for such an event
      // As such confirmDismiss is here.
      confirmDismiss: (_) {
        // We are calling an Annonymous function where we opened an AlertDialog
        showDialog(
          // This requires a context and we can pass context from the last widget where we build a context
          context: context,
          // here builder is the UI we need in this context not an iterable stuff
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to delete the item from the cart ?'),
            // These are the Actions we can add as many as we want its an childrens array
            actions: <Widget>[
              // An Alert Dialog takes some buttons sometimes so we added
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  // Here something important since the showDialog takes a return from a widget
                  // and if we dont want to confirm the dismiss event then we pass false
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  // This leads to provide true to the AlertDialog and it popouts the widget too
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      // Here we need to give an id to the dismiss panel
      key: ValueKey(id),
      // Note this background is for the backside of the child.
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),

      // Now come to child it will contain the widget tree which is on top of the dismiisble
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          // Since we are using ListTile so there are multiple easy ways to build without
          // Any container column architecture
          child: ListTile(
            // The Leading takes the very initial place of the tile
            // Here CircleAvatar creates a circular shape
            leading: CircleAvatar(
              radius: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // This argument FittedBox is usefull it reduces the text font size to fit in the box
                // without overflowing to fit in the box
                child: FittedBox(child: Text(price.toString())),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            // The 2nd and big highlighted Text
            title: Text(title),
            // A small grey font text below the title widget
            subtitle: Text(
              'Total \$' + (price * quantity).toString(),
            ),
            // its the last element of listTitle represents extreme right in a listTile
            trailing: Text(quantity.toString() + "x"),
          ),
        ),
      ),
    );
  }
}
