import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// "with" is called as mixin in dart which is somewhere as inheriting the class features
// but not exactly for now we can take it as to use features of ChangeNotifier class.

// ChangeNotifier is a class shipped with the provider package, which provide communication
// tunnels with use of context
class ProductsProvider with ChangeNotifier {
  // This property should not be accessible directly therefore we create a getter
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;
  // This will return the list of products by making a copy of the items.
  // Because when my products change I have to tell all the channels about the change

  // The auth token we will be using to use as the value for auth in url.

  List<Product> get items {
    // ... This is a spread operator which is used to return list items
    return [..._items];
  }

  List<Product> get favitems {
    // Here we sort the data to be specific to fav marked products only
    return _items.where((proditem) => proditem.isFavorite).toList();
  }

  String authToken;

  Future<void> fetchAndSetProducts(BuildContext ctx) async {
    
    authToken = Provider.of<Auth>( ctx ,listen: false).token;

    final url = 'https://fireapp-2369b.firebaseio.com/ShopApp/products.json?auth=$authToken';
    
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if(extractedData == null) return null;
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            // isFavorite: prodData['isFavourite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (onError) {}
  }

  // we created a function which returns a list item of product type taking the item
  // from the products list filtered with the id.
  // .firstWhere is a list method used to get the single item from the list
  // which mets a specific condition and condition is to check the product id is same or not
  // Since it is an annonymous function which runs everytime until it meets the condition
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    // Since we are using firebase database we can set undefined endpoints and
    // when the request recieves it will create that collection
    final url = 'https://fireapp-2369b.firebaseio.com/ShopApp/products.json?auth=$authToken';

    try {
      // ! This code is to upload product values to firebase
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          // 'isFavourite': product.isFavorite,
        }),
      );
      // ! This code is to use the upload key and then add to local list
      final newProduct = Product(
        // ! This value of id is provided by firebase response we get by posting info
        id: json.decode(response.body)['name'],
        // ! This product is provided by this addProduct method
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      // ! This is to add that data in local list
      _items.add(newProduct);
      notifyListeners();

    } 
    
    catch (onError) 
    {
      print(onError.toString());
      // throw basically provide us a functionality to send the same error again from the
      // current catch error to the next one so we can use the error again
      throw onError;
      // here in this case we will use this error in edit_product_screen where we called provider
      // to add product using this class constructor.
    }
  }

  void removeItem(String id) {
    //items.
  }
  Future<void> deleteProduct(String id) async {
    final url = 'https://fireapp-2369b.firebaseio.com/ShopApp/products/$id.json?auth=$authToken';

    await http.delete(url).then((_) {
      _items.removeWhere((prod) => prod.id == id);
    }).catchError((onError) {
      throw onError;
    });

    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://fireapp-2369b.firebaseio.com/ShopApp/products/$id.json?auth=$authToken';

      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
              'price': newProduct.price,
            }));
      } catch (onError) {}

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }
}
