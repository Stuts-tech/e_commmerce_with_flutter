import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/constants.dart';
import 'package:projectdemoapp/screens/cart_page.dart';
class CustomActionBar extends StatelessWidget {
 final String title;
 final bool backArrow;
 final bool hasTitle;

 CustomActionBar({this.title,this.backArrow,this.hasTitle});
 final CollectionReference _usersRef = FirebaseFirestore.instance.collection('Users');

  final User _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    // bool _backArrow = backArrow?? false;
    bool _hasTitle = hasTitle??true;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:[
            Colors.blueGrey,
            Colors.white,
          ]
        )
      ),
      padding: EdgeInsets.only(
        top:20.0,
        left:24.0,
        right:24.0,
        bottom:10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(backArrow)
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 38.0,
                height:38.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:Image(
                  image: AssetImage("assets/images/back_arrow.png"),
                ),
              ),
            ),
          if(_hasTitle)
        Text( title??'Action Bar',
          style: Constants.boldHeading,

          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CartPage(),
              ));
            },
           child: Container(
              width: 42.0,
              height:42.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child:
              StreamBuilder(
                stream: _usersRef.doc(_user.uid).collection("Cart").snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;

                  if(snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
                     return Text(
                       "$_totalItems" ?? 0,
        style:TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,

        ),
      );

    },
    ),
            ),
          )
        ],
      ),
    );

  }

}
