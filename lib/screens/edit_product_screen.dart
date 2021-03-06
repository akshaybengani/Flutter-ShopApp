import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/Edit-Product-Screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: null,
  );
  var _isInit = true;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productID = ModalRoute.of(context).settings.arguments as String;
      if (productID != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context).findById(productID);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((_imageUrlController.text.isEmpty) &&
          (_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))) {
        return;
      }
      setState(() {});
    }
  }

  // We need to dispose the focus nodes in order to prevent memory leak
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> myErrorDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text('Something went wrong please try again !!'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              // This is to get out from the alert dialog
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _saveForm() async {
    // this is to run the validation program build inside all form elements
    // And it will return true or false and if not then this function will return null and stops
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    // Now if the form is valid then we can save its data in local memory RAM using this
    _form.currentState.save();

    // Since now we have to send the validated saved data to cloud as such it will take time
    // and now all the async related code will work so we set the progress bar to true
    setState(() {
      // Now the build will run again and will display an empty layout
      isLoading = true;
    });

    // since in case if we get a id of an edited product this means the data is already stored in database
    // and we just neeed to update it not to add a new node.
    if (_editedProduct.id != null) {
      // we used the provider with an function we built to update data on a specific id and we have
      // not implemented the cloud version of this currently as such this is small
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } catch (onError) {
        await myErrorDialog();
      }

      // As such above line of code will not take time so we set the screen state to false without async

      // Now we need to go back to manage Products screen so we have to pop out
      Navigator.of(context).pop();
    }

    // This will execute when we have a case of new product addup not editing existing
    else {
      // A try block is used here because there can be any type of error occured during the below code
      try {
        // here the addProduct method will take time and whereever something takes time we use await
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      }

      // Catch will run after try and only if try fails
      catch (onError) {
        // since the user will take time to press ok button so we have added await
        await myErrorDialog();
        // This finally block will run after the previous two blocks not because it is below
        // But we have added await in the execution so there is no chance to run it in between
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              // Form is a hidden widget like a container and it provide several types of different form widget which help to build complex fomrs
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Product Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Title is Empty';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Price is Empty';
                        if (double.tryParse(value) == null)
                          return 'Please enter a valid number';
                        if (double.parse(value) <= 0)
                          return "Please Enter a number greater then zero";
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      focusNode: _descFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Description is Empty';
                        if (value.length < 10)
                          return "Should be at least 10 Characters long";
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : Image.network(_imageUrlController.text),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            // initialValue: _initValues['imageUrl'],
                            controller: _imageUrlController,
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) return 'ImageUrl is empty';
                              if (value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a valud URL';
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
