import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/constants.dart';
import 'package:projectdemoapp/screens/products_page.dart';

import 'package:projectdemoapp/widgets/custom_action_bar.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productRef =
      FirebaseFirestore.instance.collection('Product');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: _productRef.get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 108.0,
                    ),
                    children: snapshot.data.docs.map((document) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  productId: document.id,
                                ),
                              ));
                        },
                        child: Container(
                            child: Column(
                          children: [
                            Container(
                              height: 200.0,
                              width: 400.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: CachedNetworkImage(
                                  imageUrl: "${document.get('images')[0]}",
                                  fit: BoxFit.cover,
                                ),
                                // child: Image.network(
                                //   "${document.get('images')[0]}",
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Row(
//
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    " ${document.get('name')}",
                                    style: Constants.boldHeading,
                                  ),
                                  Text(
                                    "Rs. ${document.get('price')}",
                                    style: Constants.boldHeading,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      );
                    }).toList(),
                  );
                }
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            CustomActionBar(
              title: "home",
              hasTitle: true,
              backArrow: false,
            ),
          ],
        ),
      ),
    );
  }
}
