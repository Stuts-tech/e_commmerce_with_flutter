import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/model/cartItem.dart';
import 'package:projectdemoapp/widgets/custom_action_bar.dart';
import 'package:projectdemoapp/widgets/imageswipe.dart';
import 'package:projectdemoapp/widgets/product_size.dart';

import '../constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  User _user = FirebaseAuth.instance.currentUser;
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('Product');
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('Users');

  String _selectedProductSize = "0";

  Future _addToCart(CartItem item) {
    return _usersRef
        .doc(_user.uid)
        .collection("Cart")
        .withConverter<CartItem>(
            fromFirestore: (doc, _) => CartItem.fromDS(doc.id, doc.data()),
            toFirestore: (item, _) => item.toMap())
        .doc(widget.productId)
        .set(item);
  }

  Future _addToSaved() {
    return _usersRef
        .doc(_user.uid)
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  final SnackBar _snackBar = SnackBar(
    content: Text('Product added to cart'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
                //we used the productId to get the product from the home page
                future: _productRef.doc(widget.productId).get(),
                builder: (builder, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> documentData = snapshot.data.data();

                    List imageList = documentData['images'];
                    List productSizes = documentData['size'];
                    _selectedProductSize = productSizes[0];
                    return ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 400.0,
                              child: ImageSwipe(
                                imageList: imageList,
                              ),
                            ),
                            Container(
                              child: Text(
                                " ${documentData['name']}",
                                style: Constants.boldHeading,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: 200.0,
                              ),
                              child: Text(
                                " ${documentData['desc']}",
                                style: Constants.boldHeading,
                              ),
                            ),
                          ],
                        ),
                        ProductSize(
                          productSizes: productSizes,
                          onSelected: (val) {
                            print(val);
                            _selectedProductSize = productSizes[val];
                            print(_selectedProductSize);
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await _addToSaved();
                                },
                                child: Image(
                                  image:
                                      AssetImage("assets/images/tab_saved.png"),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  CartItem item = CartItem(
                                      name: documentData['name'],
                                      imageUrl: documentData['images'][0],
                                      price: documentData['price'],
                                      size: _selectedProductSize,
                                      productId: widget.productId,
                                      quantity: 1,
                                      userId: _user.uid);
                                  await _addToCart(item);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(_snackBar);
                                },
                                child: Container(
                                  height: 65.0,
                                  margin: EdgeInsets.only(
                                    left: 16.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
            CustomActionBar(
              hasTitle: false,
              backArrow: true,
            ),
          ],
        ),
      ),
    );
  }
}
