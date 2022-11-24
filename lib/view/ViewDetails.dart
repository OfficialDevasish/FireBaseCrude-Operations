import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/Resource/StyaleResources.dart';
import 'package:firebase_crud/view/UpdateDetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("View "),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Register").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.size <= 0) {
                return Center(
                  child: Text("No Data"),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs.map((document) {
                    return Container(
                      color: Colors.green.shade300,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name: " +
                                document["name"].toString().toUpperCase(),
                            style: StyaleResources.primaryTextstyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("email: " + document["email"].toString()),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "BirthDate: " + document["date"].toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {

                                    //pass docid next page

                                    var docid = document.id.toString();


                                    Navigator.of(context).push(MaterialPageRoute(builder:
                                        (context) => UpdateDetails(docid: docid,)));
                                  },
                                  child: Text("Update",
                                    style: TextStyle(fontSize: 20),
                                  )),
                              ElevatedButton(
                                  onPressed: () async {
                                    AlertDialog alert = AlertDialog(
                                      title: Text("My title"),
                                      content: Text("This is my message."),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              var docid = document.id.toString();
                                              await FirebaseFirestore.instance
                                                  .collection("Register")
                                                  .doc(docid)
                                                  .delete()
                                                  .then((value) {
                                                Fluttertoast.showToast(
                                                    msg: "Delete Sucsessfuly",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.green,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewDetails()));
                                              });
                                            },
                                            child: Text("yes")),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("No")),
                                      ],
                                    );

                                    // show the dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.deepOrange,
                                  ),
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
