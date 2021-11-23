import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});
  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      child: Stack(
        children: [
          PageView(
            // this onPageChanged assigns the value of the page to the selectedPage variable
            onPageChanged: (num) {
              setState(() {
                _selectedPage = num;
              });
            },
            children: [
              for (var i = 0; i < widget.imageList.length; i++)
                Container(
                   child: CachedNetworkImage(
                    imageUrl: "${widget.imageList[i]}",
                    fit: BoxFit.cover,
                  ),
                  // child: Image.network(
                  //   "${widget.imageList[i]}",
                  //   fit: BoxFit.cover,
                  // ),
                ),
            ],
          ),
          //custom design of the carousel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.imageList.length; i++)
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 6.0,
                      vertical: 6.0,
                    ),
                    width: _selectedPage == i ? 15.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
