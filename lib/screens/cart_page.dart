import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/model/cartItem.dart';
import 'package:projectdemoapp/screens/checkout_page.dart';
import 'products_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectdemoapp/widgets/custom_action_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Product");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Product");

  User _user = FirebaseAuth.instance.currentUser;

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");

  Future _deleteFromCart(String productId) {
    return _usersRef.doc(_user.uid).collection("Cart").doc(productId).delete();
  }

  List<CartItem> _cartList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("Cart")
                .withConverter<CartItem>(
                    fromFirestore: (doc, _) =>
                        CartItem.fromDS(doc.id, doc.data()),
                    toFirestore: (item, _) => item.toMap())
                .snapshots()
                .map((list) => list.docs.map((doc) => doc).toList()),
            builder: (context,
                AsyncSnapshot<List<QueryDocumentSnapshot<CartItem>>> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.hasData) {
                var documentList = snapshot.data;
                if (documentList.isEmpty) {
                  return Scaffold(
                    body: Center(
                      child: Text("Your cart is empty"),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.only(top: 108, bottom: 12),
                  itemCount: documentList.length,
                  itemBuilder: (_, i) {
                    CartItem item = documentList[i].data();
                    // _cartList.add(item);
                    return CartListItem(
                      item: item,
                      deleteFromCart: (id) {
                        _deleteFromCart(id);
                        // _cartList.removeAt(i);
                        // print("Cart Length: ${_cartList.length}");
                      },
                    );
                  },
                );
              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            backArrow: true,
            title: "Cart",
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.arrow_forward_ios),
        onPressed: () async {
          int total = 0;
          //Get cart list
          await _usersRef
              .doc(_firebaseServices.getUserId())
              .collection("Cart")
              .withConverter<CartItem>(
                  fromFirestore: (doc, _) =>
                      CartItem.fromDS(doc.id, doc.data()),
                  toFirestore: (item, _) => item.toMap())
              .get().then((value) {
                _cartList = value.docs.map((e) => e.data()).toList();
                value.docs.map((e) => total += e.data().price);
                print(total);
              });
              print("Cart List: ${_cartList.length}");
          //Go to checkout
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutPage(
                emailAddress: _user.email,
                cartList: _cartList,
                userId: _user.uid,
                total: total,
              ),
            ),
          );
        },
        label: Text("Checkout"),
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  final CartItem item;
  final Function(String id) deleteFromCart;
  const CartListItem(
      {Key key, @required this.item, @required this.deleteFromCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productId: item.productId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 90,
              height: 90,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: "${item.imageUrl}",
                  fit: BoxFit.cover,
                ),
                // child: Image.network(
                //   "${item.imageUrl}",
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.name}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                    ),
                    child: Text(
                      "\$${item.price}",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "Size - ${item.size}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              //to remove item
              child: FloatingActionButton(
                onPressed: () {
                  deleteFromCart(item.id);
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.deepOrange,
                ),
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
