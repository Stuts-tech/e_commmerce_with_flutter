import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import'package:flutter/material.dart';
import 'package:projectdemoapp/constants.dart';
import 'package:projectdemoapp/screens/Loginpage.dart';

import 'HomePage.dart';


class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder:(context,snapshot){
          if (snapshot.hasError){
            return Scaffold(
              body:Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body:StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder:(context,streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: ${streamSnapshot.error}'),
                      ),
                    );
                  }

                  if(streamSnapshot.connectionState==ConnectionState.active){
                    User _user= streamSnapshot.data;//this takes the user data from the stream builder where User from firebase package and _user is a private variable
                  // now we check if the user is logged in or not with if else statement and redirect to the respective pages
                    if(_user ==null){
                      return LoginPage();
                    }else{
                      return HomePage(); // we can also navigate  instead
                    }
                  }




                  return Scaffold(
                    body: Center(
                        child: Text('Checking Authentication....',
                        style: Constants.regularHeading,)

                    ),

                  );
                }
              ),

          );
          }

          return Scaffold(
            body:Center(
                child:Text('Initializing App....')
            ),

          );

          }

    );
  }
}
