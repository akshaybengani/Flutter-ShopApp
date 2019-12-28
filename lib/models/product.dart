import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String imageUrl;
  final String title;
  final double price;
  final String description;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });
}
