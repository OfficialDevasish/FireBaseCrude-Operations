import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/view/UpdateImageWithDetail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewWithDetails extends StatefulWidget {
  @override
  State<ViewWithDetails> createState() => _ViewWithDetailsState();
}

class _ViewWithDetailsState extends State<ViewWithDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("viewdetails"),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("addwithimg").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.size <= 0) {
                return Center(
                  child: Text("no data"),
                );
              } else {
                return ListView(
                  children: snapshot.data.docs.map((documents) {
                    return Container(
                      color: Colors.blue.shade100,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
                                child: Image.network(
                                  documents["imageurl"],
                                  width: 160.0,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Text(
                                      documents["name"]
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "name: " + documents["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "email: " + documents["email"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "date: " + documents["date"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: ()async{

                                var docid = documents.id.toString();
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context)=>UpdateImageWithDetail(docid: docid,))
                                );

                              },
                                  child: Text("Update")),
                              // ElevatedButton(
                              // onPressed: ()async{

                              // child: Text("Update"),
                              // ),
                              ElevatedButton(
                                onPressed: () async {
                                  AlertDialog alert = AlertDialog(
                                    title: Text(
                                      "Warning",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 25),
                                    ),
                                    content: Text("Are You Sure This Delete"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          var docid = documents.id.toString();

                                          await FirebaseStorage.instance
                                              .ref(documents["imagename"])
                                              .delete()
                                              .then((value) async {
                                            await FirebaseFirestore.instance
                                                .collection("addwithimg")
                                                .doc(docid)
                                                .delete()
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            });
                                          });
                                        },
                                        child: Text("Yes"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red),
                                child: Text("Delete"),
                              ),
                            ],
                          ),
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
          }),
    );
  }
}
