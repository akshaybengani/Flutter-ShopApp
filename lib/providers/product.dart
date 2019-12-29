import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
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

    // notifyListeners is something like setState of provider package
    void toggleFavoriteStatus(){
      // Whenever we call this function the status of favourite changes
      isFavorite = !isFavorite;
      notifyListeners();
    }

}
