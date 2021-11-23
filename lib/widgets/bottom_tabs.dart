import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ButtonTab extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;
  ButtonTab({this.selectedTab,this.tabPressed});
  @override
  _ButtonTabState createState() => _ButtonTabState();
}

class _ButtonTabState extends State<ButtonTab> {
  int _selectedTab=0;






  @override
  Widget build(BuildContext context) {
    _selectedTab= widget.selectedTab??0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
        ),
        boxShadow: [
          BoxShadow(
            color:Colors.black.withOpacity(0.05),
            spreadRadius: 1.0,
            blurRadius: 30.0,
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomTabs(
            imagePath: "assets/images/tab_home.png",
             selected: _selectedTab==0? true:false,
             onPressed:(){
               widget.tabPressed(0);


             },

          ),
          BottomTabs(
              imagePath:"assets/images/tab_saved.png",
            selected: _selectedTab==1? true:false,
    onPressed:(){
    widget.tabPressed(1);
    }
    ),
          BottomTabs(
            imagePath:"assets/images/tab_search.png",
            selected: _selectedTab==2? true:false,
    onPressed:(){
      widget.tabPressed(2);
    }),
          BottomTabs(
            imagePath:"assets/images/tab_logout.png",
            selected: _selectedTab==3? true:false,
       onPressed:() {
      FirebaseAuth.instance.signOut();
    }
    ),

        ],

      ),
    )
    ;
  }
}







class BottomTabs extends StatelessWidget {
  final bool selected;
  final String imagePath;
  final Function onPressed;

  BottomTabs({this.imagePath,this.selected,this.onPressed});
  @override
  Widget build(BuildContext context) {
    bool _selected = selected??false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 22.0,
          horizontal: 16.0,

        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(

              color: _selected? Theme.of(context).accentColor:Colors.transparent,
              width:2.0,
            )
          )
        ),
        child: Image(
          image:AssetImage(
             imagePath?? "assets/images/tab_home.png"),
          width: 26.0,
          height:26.0,
          color: _selected?Theme.of(context).accentColor:Colors.black,

        ),
      ),
    );
  }
}
