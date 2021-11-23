import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/model/cartItem.dart';
import 'package:projectdemoapp/model/order.dart';
import 'package:projectdemoapp/services/db_services.dart';
import 'package:projectdemoapp/utils/utils.dart';

class CheckoutPage extends StatefulWidget {
  final String userId;
  final int total;
  final String deliveryAddress;
  final String emailAddress;
  final int phoneNumber;
  final List<CartItem> cartList;

  const CheckoutPage({
    Key key,
    @required this.userId,
    @required this.total,
    this.deliveryAddress,
    this.emailAddress,
    this.phoneNumber,
    @required this.cartList,
  }) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _deliveryAddress;
  TextEditingController _emailAddress;
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _coupon;
  TextEditingController _specialNote;

  User _user = FirebaseAuth.instance.currentUser;

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('Users');

  @override
  void initState() {
    _deliveryAddress = TextEditingController(text: widget.deliveryAddress);
    _emailAddress = TextEditingController(text: widget.emailAddress);
    // _phoneNumber = TextEditingController(text: widget.phoneNumber.toString());
    _phoneNumber.text = widget.phoneNumber.toString() == "null"
        ? ""
        : widget.phoneNumber.toString();
    _coupon = TextEditingController();
    _specialNote = TextEditingController();
    super.initState();
  }

  Future<void> _deleteCartItems() async {
    for (int i = 0; i < widget.cartList.length; i++) {
      _usersRef
          .doc(_user.uid)
          .collection("Cart")
          .doc(widget.cartList[i].id)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // deleteCartItems() {
    //   context.read<CartProvider>().deleteCart();
    // }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Checkout",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(36),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                
                // delivery address
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "*Delivery Address can't be empty.";
                    return null;
                  },
                  controller: _deliveryAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Delivery Address*",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // email address
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "*Email Address can't be empty.";
                    return null;
                  },
                  controller: _emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Email Address*",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Phone Number
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) return "*Phone Number can't be empty.";
                    return null;
                  },
                  controller: _phoneNumber,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Phone Number*",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Coupon
                TextFormField(
                  validator: (val) {
                    return null;
                  },
                  controller: _coupon,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: "Coupon(Optional)",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                // Special Note
                TextFormField(
                  validator: (val) {
                    return null;
                  },
                  controller: _specialNote,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Special Note(Optional)",
                    labelStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                //Save Button
                const SizedBox(height: 20.0),
                ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Confirm Order",
                    ),
                  ),
                  onPressed: () async {
                    ConnectivityResult connectivity =
                        await Connectivity().checkConnectivity();
                    if (connectivity == ConnectivityResult.none) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Check Your Internet Connection! Try again later.")));
                    }
                    if (_formKey.currentState.validate()) {
                      Order myOrder = Order(
                        deliveryAddress: _deliveryAddress.text,
                        emailAddress: _emailAddress.text,
                        mobileNumber: Utils.strToInt(_phoneNumber.text),
                        orderDate: DateTime.now(),
                        orderState: "processing",
                        orderedItems: widget.cartList.map((cartItem) {
                          OrderedItem orderedItem = OrderedItem(
                            name: cartItem.name,
                            imageUrl: cartItem.imageUrl,
                            price: cartItem.price,
                            productId: cartItem.productId,
                            quantity: cartItem.quantity,
                          );
                          return orderedItem;
                        }).toList(),
                        totalAmount: widget.total,
                        userId: widget.userId,
                        coupon: _coupon.text,
                        specialNote: _specialNote.text,
                      );
                      await orderItemDb.createItem(myOrder).then((value) async {
                        _deleteCartItems();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Order Placed Successfully")));
                        Navigator.of(context).pop();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Fix The Error First")));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
