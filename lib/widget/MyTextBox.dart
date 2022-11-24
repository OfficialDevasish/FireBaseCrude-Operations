import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {


  var hinttext="";
  bool ispassword=false;
  TextEditingController controller;
  TextInputType keyboard;

  MyTextBox({this.hinttext,this.ispassword,this.controller,this.keyboard});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: ispassword,
      controller: controller,
      decoration:InputDecoration(
        hintText: hinttext,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)),
      ),
      keyboardType: keyboard,
    );
  }
}
