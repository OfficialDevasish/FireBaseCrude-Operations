import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/view/HomeScreen.dart';
import 'package:firebase_crud/widget/MyPrimaryButton.dart';
import 'package:firebase_crud/widget/MyTextBox.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginScreen"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _name,
                ispassword: false,
                hinttext: "entre your Name",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("email",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _email,
                ispassword: false,
                hinttext: "entre your email",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              MyPrimaryButton(
                onclick: ()async{

                  var name = _name.text.toString();
                  var email = _email.text.toString();


                  await FirebaseFirestore.instance.collection("Register").where("name",isEqualTo: name)
                      .where("email",isEqualTo: email).get().then((documents) async{
                      if(documents.size>=1)
                        {
                          print("Match");
                          var name = documents.docs.first["name"].toString();
                          var email = documents.docs.first["email"].toString();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("fname", name);
                          prefs.setString("email", email);
                          
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context)=>HomeScreen())
                          );
                          
                        }
                      else
                        {
                          print("Not match");
                        }
                  });

                },
                buttonText: "login",
              )
            ],
          ),
        ),
      ),
    );
  }
}
