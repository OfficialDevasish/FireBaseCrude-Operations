
import 'package:firebase_crud/Resource/StyaleResources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPrimaryButton extends StatefulWidget {

  GestureTapCallback onclick;

  var buttonText;

  MyPrimaryButton({this.onclick,this.buttonText});


  @override
  State<MyPrimaryButton> createState() => _MyPrimaryButtonState();
}

class _MyPrimaryButtonState extends State<MyPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onclick,

      child: Container(
        alignment: Alignment.center,
        decoration: new BoxDecoration (
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
            color: Colors.blue.shade100
        ),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Text(widget.buttonText,style: StyaleResources.primaryTextstyle,),
      ),

    );
  }
}