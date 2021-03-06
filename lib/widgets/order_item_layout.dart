import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderItemLayout extends StatefulWidget {
  final OrderItem order;

  OrderItemLayout(this.order);

  @override
  _OrderItemLayoutState createState() => _OrderItemLayoutState();
}

class _OrderItemLayoutState extends State<OrderItemLayout> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    // So here we need the Animated Container only else everything is same
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 150, 300) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$' + widget.order.amount.toString()),
              subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm')
                  .format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 50, 300)
                  : 0,
              child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(prod.quantity.toString() +
                                ' x \$' +
                                prod.price.toString()),
                          ],
                        ),
                      )
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
