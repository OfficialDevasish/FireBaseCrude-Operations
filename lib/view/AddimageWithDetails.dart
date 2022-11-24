import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Resource/StyaleResources.dart';
import '../widget/MyPrimaryButton.dart';
import '../widget/MyTextBox.dart';

class AddimageWithDetails extends StatefulWidget {
  @override
  State<AddimageWithDetails> createState() => _AddimageWithDetailsState();
}

class _AddimageWithDetailsState extends State<AddimageWithDetails> {
  TextEditingController _name = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _date = TextEditingController();

  String time = '?';

  File imagefile = null;
  ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("AddUImageWithDetails"),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.red.shade50,
                width: MediaQuery.of(context).size.width,
                child: (imagefile != null)
                    ? Image.file(
                        imagefile,
                        height: 300.0,
                      )
                    : Image.asset(
                        "img/wait.jpg",
                        height: 300.0,
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("camera"),
                IconButton(
                  onPressed: () async {
                    XFile photo =
                        await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      imagefile = File(photo.path);
                    });
                  },
                  icon: Icon(
                    Icons.camera,
                  ),
                  iconSize: 50,
                  color: Colors.green,
                  splashColor: Colors.purple,
                ),
                Text("galary"),
                IconButton(
                  icon: Icon(
                    Icons.browse_gallery_rounded,
                  ),
                  iconSize: 50,
                  color: Colors.green,
                  splashColor: Colors.purple,
                  onPressed: () async {
                    XFile photo =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      imagefile = File(photo.path);
                    });
                  },
                ),
              ]),
              Text(
                "Name",
                style: StyaleResources.primaryTextstyle,
              ),
              SizedBox(
                height: 10,
              ),
              MyTextBox(
                controller: _name,
                ispassword: false,
                hinttext: "Addyourname",
                keyboard: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Email",
                style: StyaleResources.primaryTextstyle,
              ),
              SizedBox(
                height: 10,
              ),
              MyTextBox(
                controller: _email,
                ispassword: false,
                hinttext: "AddYourEmail",
                keyboard: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              Text("BirthDate", style: StyaleResources.primaryTextstyle),
              SizedBox(
                height: 10,
              ),
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
              SizedBox(
                height: 10,
              ),
              MyPrimaryButton(
                onclick: () async {
                  var name = _name.text.toString();
                  var email = _email.text.toString();
                  var date = _date.text.toString();

                  var uuid = Uuid();
                  var filename = uuid.v4().toString() + ".jpg";

                  await FirebaseStorage.instance
                      .ref(filename)
                      .putFile(imagefile)
                      .whenComplete(() {})
                      .then((filedata) async {
                    await filedata.ref.getDownloadURL().then((fileurl) async {
                      await FirebaseFirestore.instance
                          .collection("addwithimg")
                          .add({
                        "name": name,
                        "email": email,
                        "date": date,
                        "imagename": filename,
                        "imageurl": fileurl
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg: "add Sucsess",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        _name.text = "";
                        _email.text = "";
                        _date.text = "";
                      });
                    });
                  });
                },
                buttonText: "add",
              )
            ],
          ),
        ),
      ),
    );
  }
}
