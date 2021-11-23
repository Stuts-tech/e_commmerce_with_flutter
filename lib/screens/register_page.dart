import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectdemoapp/screens/Loginpage.dart';
import 'package:projectdemoapp/widgets/custom_widgets.dart';

import '../constants.dart';
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //alert box to display error

  Future<void> _alertDailogueBuilder( String error) async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          title: Text('Error'),
          content: Container(
            child:Text(error),
          ),
          actions:[
          TextButton(
            child:Text('Close Dailogue'),
            onPressed: (){
              Navigator.pop(context);
        },

          ),

          ],
        );
      }

    );
  }
  Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _registerEmail, password: _registerPassword);
      return null;

    }on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
       return'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
       return'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }

  }
  void _submitForm() async{
    //set the form to loading state
    setState(() {
      _registerFormLoading=true;
    });
    String _createAccountFeedback = await _createAccount();

    if(_createAccountFeedback!=null){
      _alertDailogueBuilder(_createAccountFeedback);
      setState(() {
        _registerFormLoading=false;
      });
    } else{
      Navigator.pop(context);
    }

  }
  bool _registerFormLoading=false;
  String _registerEmail="";
  String _registerPassword="";
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          width:double.infinity,
          child:SingleChildScrollView(
            child: Column(
              children: [
                Column(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Sign Up Page",
                        textAlign: TextAlign.center,
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(padding: const EdgeInsets.all(50.0),),
                    CustomInputButton(
                      hinText: ('email...'),
                      onChanged: (value){
                        _registerEmail=value;
                      },
                      onSubmitted: (value) {
                        _passwordFocusNode.requestFocus();
                      },



                    ),
                    CustomInputButton(
                      hinText: ('password...'),
                      isPasswordField: true,


                      onChanged: (value){
                        _registerPassword=value;
                      },
                      onSubmitted: (value) {
                        _submitForm();
                      },

                      focusNode: _passwordFocusNode,

                      textInputAction: TextInputAction.next,



                    ),
                    CustomButton(
                      text:('Sign Up'),
                      onPressed: (){
                        _submitForm();
                        setState(() {
                          _registerFormLoading=true;
                        });

                      },

                     isLoading: _registerFormLoading,
                    ),
                  ],

                ),

                CustomButton(
                  text:'Sign In',
                  onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),),
                  );

                  },
                  outlineButton: true,
                ),

              ],

            ),
          ),
        ),
      ),
    );
  }
}
