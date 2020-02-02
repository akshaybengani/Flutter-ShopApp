import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

class Product with ChangeNotifier {
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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  // notifyListeners is something like setState of provider package
  Future<void> toggleFavoriteStatus(BuildContext ctx) async {
    // Whenever we call this function the status of favourite changes

    String authToken = Provider.of<Auth>(ctx, listen: false).token;
    String userId = Provider.of<Auth>(ctx, listen: false).userId;

    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://fireapp-2369b.firebaseio.com/ShopApp/userFavorites/$userId/id.json?auth=$authToken';
    try {
      final response = await http.put(url, body: json.encode(isFavorite) );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
