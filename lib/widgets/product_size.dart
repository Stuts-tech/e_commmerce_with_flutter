import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ProductSize extends StatefulWidget {
  final List productSizes;

  final Function(int) onSelected;
  ProductSize({this.productSizes, this.onSelected});
  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected=0;
  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        for(var i=0; i<widget.productSizes.length;i++)

          GestureDetector(
            onTap: (){

              setState(() {
                _selected=i;
                widget.onSelected(_selected);
              });
            },
            child: Container(
              width: 60.0,
              height:42.0,
              decoration: BoxDecoration(
                color: _selected==i?Colors.pinkAccent:Colors.blueGrey,
                borderRadius: BorderRadius.circular(8.0)
              ),
              alignment: Alignment.center,
              margin: EdgeInsets.all(8.0),
              child: Text('${widget.productSizes[i]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:_selected==i?Colors.white: Colors.black,
              ),),
            ),
          ),
      ],
    );
  }
}
