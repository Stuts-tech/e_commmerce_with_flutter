import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool outlineButton;
  final bool isLoading;

  const CustomButton({ this.text, this.onPressed, this.outlineButton,this.isLoading}) ;
  // after we initialized final variables we initialize a constructor for it




  @override
  Widget build(BuildContext context) {

    bool _outlineButton = outlineButton?? false;
    bool _isLoading = isLoading??false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(

        height:50.0,

        decoration: BoxDecoration(
          color:_outlineButton? Colors.transparent : Colors.black,
          border: Border.all(
            color:Colors.black,
            width:2.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24.0,
        ),
        child: Stack(
          children:[
            Visibility(
              visible: _isLoading? false:true,

              child: Center(
                child: Text(
                text??'Text',

                style: TextStyle(fontSize: 16.0,
                fontWeight: FontWeight.w600,
                  color:_outlineButton? Colors.black : Colors.white,//ternary operator used to set either black or white to the text color
                ),
          ),
              ),
            ),
            Visibility(
                visible: _isLoading,
                child: Center(child: CircularProgressIndicator())),
        ],
      ),

      ),
    );
  }
}

class CustomInputButton extends StatelessWidget {
  final String hinText;
  final Function(String) onChanged;
  final Function (String) onSubmitted;
  final FocusNode focusNode;
  final bool isPasswordField;

  final TextInputAction textInputAction;
  CustomInputButton({this.hinText,this.onChanged,this.onSubmitted,this.focusNode,this.isPasswordField, this.textInputAction});
  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = isPasswordField??false;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical:12.0,
        horizontal:12.0,

      ),
      decoration: BoxDecoration(
        color:Colors.grey,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        obscureText: _isPasswordField,
        autofocus: true,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border:InputBorder.none,
          hintText: hinText??'Hint Text...',
          contentPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical:18.0,
          ),
        ),

      ),
    );
  }
}

