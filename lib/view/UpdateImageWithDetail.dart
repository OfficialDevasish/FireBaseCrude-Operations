

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/widget/MyPrimaryButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../widget/MyTextBox.dart';

class UpdateImageWithDetail extends StatefulWidget {

  var docid="";
  UpdateImageWithDetail({this.docid});

  @override
  State<UpdateImageWithDetail> createState() => _UpdateImageWithDetailState();
}

class _UpdateImageWithDetailState extends State<UpdateImageWithDetail> {

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _date = TextEditingController();


  File imagefile=null;
  ImagePicker _picker = ImagePicker();

  var oldimagename="";
  var oldimagefileurl="";
var time="";

  getdata()async{
    await FirebaseFirestore.instance.collection("addwithimg").doc(widget.docid).get().then((documents)async{
      setState(() {
        _name.text = documents["name"].toString();
        _email.text = documents["email"].toString();
        _date.text = documents["date"].toString();
        oldimagename = documents["imagename"].toString();
        oldimagefileurl = documents["imageurl"].toString();

      });
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
        title: Text("Update"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                color: Colors.red.shade50,
                width: MediaQuery.of(context).size.width,
                child:  (imagefile!=null)?Image.file(imagefile,height: 300.0,):(oldimagefileurl!="")? Image.network(oldimagefileurl,height: 300.0,):Image.asset("img/wait.jpg"),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: ()async{
                      XFile photo = await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },

                    child: Text("Camera"),
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                      XFile photo = await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imagefile = File(photo.path);
                      });
                    },

                    child: Text("Gallery"),
                  ),
                ],
              ),
              Text("Name"),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _name,
                ispassword: false,
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("email"),
              SizedBox(height: 10,),
              MyTextBox(
                controller: _email,
                ispassword: false,
                keyboard: TextInputType.text,
              ),
              SizedBox(height: 10,),
              Text("date"),
              SizedBox(height: 10,),
              Stack(alignment: const Alignment(1.0, 1.0), children: <Widget>[
                new TextField(
                  controller: _date,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                new IconButton(
                    onPressed: () async {
                      var datePicked = await DatePicker.showSimpleDatePicker(
                        context,
                        initialDate: DateTime(2022),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(2025),
                        dateFormat: "dd-MM-yyyy",
                        itemTextStyle:
                        (TextStyle(fontSize: 17, color: Colors.blue)),
                        looping: true,
                      );
                      setState(() {
                        String formattedDate =
                        DateFormat('DD-MM-yyyy').format(datePicked);
                        time = formattedDate.toString();
                        _date.text = time;
                      });
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.blue,
                    )),
              ]),
              MyPrimaryButton(

                onclick: ()async{
                  var name = _name.text.toString();
                  var email = _email.text.toString();
                  var date = _date.text.toString();



                  if(imagefile!=null)
                  {
                    await FirebaseStorage.instance.ref(oldimagename).delete().then((value) async {
                      var uuid = Uuid();
                      var filename = uuid .v4().toString()+".jpg";

                      await FirebaseStorage.instance.ref(filename).putFile(imagefile).whenComplete((){}).then((filedata)async{
                        await filedata.ref.getDownloadURL().then((fileurl)async{

                          await FirebaseFirestore.instance.collection("addwithimg").doc(widget.docid).update({
                            "name": name,
                            "qty": email,
                            "rprice": date,

                            "imagename":filename,
                            "imageurl":fileurl
                          }).then((value) {
                            Fluttertoast.showToast(
                                msg: "Update Sucsess",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            Navigator.of(context).pop();
                            _name.text="";
                            _email.text="";
                            _date.text="";

                          });

                        });
                      });

                    });
                  }
                  else
                  {
                    await FirebaseFirestore.instance.collection("addwithimg").doc(widget.docid).update({
                      "name": name,
                      "qty": email,
                      "rprice": date,

                    }).then((value)  {
                      Navigator.of(context).pop();
                    });
                  }

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
