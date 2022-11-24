import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Resource/StyaleResources.dart';
import 'package:firebase_crud/widget/MyPrimaryButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/MyTextBox.dart';

class AddDetails extends StatefulWidget {


  @override
  State<AddDetails> createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {


  TextEditingController _name = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _date = TextEditingController();

  String time = '?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("AddDetails"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blueGrey.shade300,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name",style: StyaleResources.primaryTextstyle,),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _name,
                ispassword: false,
                hinttext: "Addyourname",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("Email",style: StyaleResources.primaryTextstyle,),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _email,
                ispassword: false,
                hinttext: "AddYourEmail",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),

              Text("BirthDate",style:StyaleResources.primaryTextstyle),
              SizedBox(height: 10,),
              Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    new TextField(
                      controller: _date,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, ),
                        ),
                      ),
                    ),
                    new IconButton(
                        onPressed: ()async {
                          var datePicked = await DatePicker.showSimpleDatePicker(
                            context,
                            initialDate: DateTime(2022),
                            firstDate: DateTime(1960),
                            lastDate: DateTime(2025),
                          dateFormat: "dd-MM-yyyy",itemTextStyle: (TextStyle(fontSize: 17,color: Colors.blue)),
                            looping: true,
                          );
                          setState(() {
                            String formattedDate = DateFormat('DD-MM-yyyy').format(datePicked);
                            time=formattedDate.toString();
                            _date.text = time;
                          });
                        },
                        icon: Icon(Icons.calendar_today_outlined,color: Colors.white,)),
                  ]
              ),
              SizedBox(height: 10,),
              MyPrimaryButton(
                onclick: ()async{

                  var name = _name.text.toString();
                  var email = _email.text.toString();
                  var date = _date.text.toString();
                  if(name.length<=0)
                    {
                      Fluttertoast.showToast(
                          msg: "plese add your name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }
                  else if(email.length<=0)
                  {
                    Fluttertoast.showToast(
                        msg: "please add your email",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else if(date.length<=0)
                  {
                    Fluttertoast.showToast(
                        msg: "please add your birth date",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else{

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("fname", name);
                    prefs.setString("femail", email);

                    await FirebaseFirestore.instance.collection("Register").add({
                      "name":name,
                      "email":email,
                      "date":date,
                    }).then((value) {
                      _name.text="";
                      _email.text="";
                      _date.text="";
                      Fluttertoast.showToast(
                          msg: "add Sucsess",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    });
                  }




                },
                buttonText: "add",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
