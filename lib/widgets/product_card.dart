import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/constants.dart';
import 'package:projectdemoapp/screens/products_page.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final Function onPressed;
  final String imageUrl;
  final String title;
  final String price;
  ProductCard(
      {this.onPressed, this.imageUrl, this.title, this.price, this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                productId: productId,
              ),
            ));
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          height: 350.0,
          margin: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 24.0,
          ),
          child: Container(
              child: Column(
            children: [
              Container(
                height: 200.0,
                width: 400.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: "$imageUrl",
                    fit: BoxFit.cover,
                  ),
                  // child: Image.network(
                  //   "$imageUrl",
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
//
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Constants.boldHeading,
                    ),
                    Text(
                      price,
                      style: Constants.boldHeading,
                    ),
                  ],
                ),
              ),
            ],
          ))),
    );
  }
}
