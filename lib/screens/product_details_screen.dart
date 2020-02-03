import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routename = '/productDetails';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

/*
    final loadedProduct = Provider.of<ProductsProvider>(context)
        .items.firstWhere((prod) => prod.id == productId);
*/
    // Here we have uses the same logic as the above one just we created a function in
    // our provider package which provide us Product item filteing with id as an argument
    // We have added the listen to stop listening automatically when the data is changed
    // since we dont need automatic updates in this screen and by default is is set to true
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      // Since in order to use silvers and provide a custom appbar hide animation,
      // We need more detailed look on the scrollview and therefore we used the CustomScrollview
      body: CustomScrollView(
        // So Slivers is actually the parts of the scroll view so currently we are using
        // The SliversAppBar and SliversList which means we can add something in the appbar
        // As a background remember like in whatsapp Group info Screen we get the
        // Group image as background of the appbar and when we scroll down to the list members
        // we get the image as an AppBar with a text of group name so here we have something similar
        // the text of appbar is still shown on the appbar but when the user scrolls the screen the
        // app bar image gets faded and we just get a text
        slivers: <Widget>[
          SliverAppBar(
            // The expanded height is the max height in this case
            expandedHeight: 300,
            // Its pinned true means when we scroll it down do we still need to show the appbar or not
            pinned: true,
            // The flexiblespace is the widget which takes the value of the appbarsilver content
            flexibleSpace: FlexibleSpaceBar(
              // Its totally look like an Appbar config where we pass a Title a background or something like a gradient
              title: Text(loadedProduct.title),
              // The background here takes the hero animation which consist of an Image
              background:
                  //  Hero is a widget which is used to add animations while opening
                  // screens. Here in hero we need to give it a unique id to work and
                  // we are giving our product id. Now we need to add something in the
                  // recieveing screen. The hero Animation is great since it provides
                  // that zoom in feature from where we have to zoom. And zoom out
                  // without any extra code so it is so simple without any _controller.
                  // The hero animation takes the same tag id value as the previous one takes
                  Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // The SliverList is the list of Widgets which we want to add in scrollview and that takes
          // delegate of SilverChildListDelegate just remember that and that list will take everything from there
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$' + loadedProduct.price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 500),
            ]),
          ),
        ],
      ),
    );
  }
}
