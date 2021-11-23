
import 'package:flutter/material.dart';
import 'package:projectdemoapp/tab/home_tab.dart';
import 'package:projectdemoapp/tab/Search.dart';
import 'package:projectdemoapp/tab/Saved.dart';
import 'package:projectdemoapp/widgets/bottom_tabs.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabPageController;
  int _selectedTab=0;
  @override
  void initState() {
    _tabPageController= PageController();
    super.initState();
  }
  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Expanded(
           child:PageView(
             controller: _tabPageController,
             onPageChanged: (num){
               setState(() {
                 _selectedTab=num;
               });

             },
             children: [
              HomeTab(),
               SavedTab(),
               SearchTab(),

             ],

      ),


          ),
          ButtonTab(
            selectedTab: _selectedTab,
            tabPressed: (num){

               _tabPageController.animateToPage(
                   num,
                   duration:Duration(milliseconds: 300),
                   curve:Curves.easeOutCubic);


            },
          ),
        ],
      )
    );
  }
}
