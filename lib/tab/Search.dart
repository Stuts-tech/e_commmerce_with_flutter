import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/widgets/custom_widgets.dart';
import 'package:projectdemoapp/widgets/product_card.dart';

import '../constants.dart';


class FirebaseServices {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef = FirebaseFirestore
      .instance
      .collection("Product");

  final CollectionReference usersRef = FirebaseFirestore
      .instance
      .collection("Users");

}

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (_searchString.isEmpty)
            Center(
              child: Container(
                child: Text(
                  "Search Results",
                  style: Constants.regularHeading,
                ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef
                  .orderBy("name")
                  .startAt([_searchString]).endAt(
                  ["$_searchString\uf8ff"]).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                // Collection Data ready to display
                if (snapshot.connectionState == ConnectionState.done) {
                  // Display the data inside a list view
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 128.0,
                      bottom: 12.0,
                    ),
                    children: snapshot.data.docs.map((document) {
                      return ProductCard(
                        title: document.get('name'),
                        imageUrl: document.get('images')[0],
                        price: "\$${document.get('price')}",
                        productId: document.id,
                      );
                    }).toList(),
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
          Padding(
            padding: const EdgeInsets.only(
              top: 45.0,
            ),
            child: CustomInputButton(
              hinText: "Search here...",
              onSubmitted: (value) {
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}








//class SearchTab extends StatefulWidget {
//  @override
//  _SearchTabState createState() => _SearchTabState();
//}
//
//class _SearchTabState extends State<SearchTab> {
//  FirebaseServices _firebaseServices = FirebaseServices();
//
//  final CollectionReference productsRef = FirebaseFirestore
//      .instance
//      .collection("Product");
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Column(
//        children: [
//          SizedBox(height: 45.0,),
//          CustomInputButton(
//            hinText: "Search here...",
//            onSubmitted: (value){
//              if(value.isNotEmpty){
//
//              }
//            },
//          ),
//          SizedBox(height: 20.0,),
//          Text("Search Results",style: Constants.boldHeading),
//          FutureBuilder<QuerySnapshot>(
//            future: productsRef.get(),
//            builder:(context,snapshot){
//              if (snapshot.hasError){
//                return Scaffold(
//                  body:Center(
//                    child: Text('Error: ${snapshot.error}'),
//                  ),
//                );
//              }
//              if(snapshot.connectionState==ConnectionState.done){
//                return ListView(
//                  padding: EdgeInsets.only(
//                    top:108.0,
//                  ),
//                  children:
//                  snapshot.data.docs.map((document){
//                    return GestureDetector(
//                      onTap:(){
//                        Navigator.push(context,
//                            MaterialPageRoute(
//                              builder: (context)=>ProductPage(productId:document.id,),
//                            ) );
//                      } ,
//                      child: Container(
//                          child:Stack(
//                            children: [
//                              Container(
//                                height:200.0,
//                                width:400.0,
//
//                                child: ClipRRect(
//                                  borderRadius: BorderRadius.circular(12.0),
//                                  child: Image.network("${document.get('images')[0]}",
//                                    fit:BoxFit.cover,
//                                  ),
//                                ),
//
//                              ),
//                              Padding(
//                                padding: EdgeInsets.all(12.0),
//                                child: Row(
////
//                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                  children: [
//
//                                    Text(
//                                      " ${document.get('name')}",
//                                      style: Constants.boldHeading,
//                                    ),
//                                    Text("Rs. ${document.get('price')}",
//                                      style: Constants.boldHeading,
//                                    ),
//                                  ],
//
//                                ),
//
//                              ),
//
//                            ],
//                          )
//
//                      ),
//                    );
//
//                  }).toList(),
//
//                );
//              }
//              return Scaffold(
//                body:Center(
//                  child:CircularProgressIndicator(),
//                ),
//              );
//            },
//          ),
//
//        ],
//      ),
//    );
//  }
//}