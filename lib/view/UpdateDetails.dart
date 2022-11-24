import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/widget/MyPrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Resource/StyaleResources.dart';
import '../widget/MyTextBox.dart';

class UpdateDetails extends StatefulWidget {

  var docid="";

  UpdateDetails({this.docid});
  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {


  TextEditingController _name = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _date = TextEditingController();

  String time = '?';

  getdata()async{

    await FirebaseFirestore.instance.collection("Register").doc(widget.docid).get().then((document)async{
      _name.text = document["name"].toString();
      _email.text = document["email"].toString();
      _date.text = document["date"].toString();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Update your detail"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _name,
                ispassword: false,
                hinttext: "",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("email",style: StyaleResources.primaryTextstyle,),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _email,
                ispassword: false,
                hinttext: "",
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("BirthDate",style: StyaleResources.primaryTextstyle,),
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
                            String formattedDate = DateFormat('MM-DD-yyyy').format(datePicked);
                            time=formattedDate.toString();
                            _date.text = time;
                          });
                        },
                        icon: Icon(Icons.calendar_today_outlined,color: Colors.blue,)),
                  ]
              ),
              MyPrimaryButton(
                onclick: ()async{

                  var name = _name.text.toString();
                  var email = _email.text.toString();
                  var  date = _date.text.toString();


                  await FirebaseFirestore.instance.collection("Register").doc(widget.docid).update({

                    //je add time par parameter hoy te j same pass karva

                    "name":name,
                    "email":email,
                    "date":date,
                  }).then((value){
                    Fluttertoast.showToast(
                        msg: "Update Sucsess Fuly",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    Navigator.of(context).pop();
                  });
                },
                buttonText: "Update",
              )
            ],
          ),
        ),
      ),
    );
  }
}
