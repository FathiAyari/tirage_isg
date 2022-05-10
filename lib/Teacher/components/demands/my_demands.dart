import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'add_demand.dart';
//teacher

var dataSnapshot = FirebaseFirestore.instance;

class My_demands extends StatefulWidget {
  const My_demands({Key? key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<My_demands> {
  TextEditingController docName = TextEditingController();
  TextEditingController classe = TextEditingController();
  TextEditingController number = TextEditingController();
  String pdfFileName = "cliquer pour choisir un pdf ";

  late FilePickerResult result;

  File? pdfFile;
  late String uid;
  Future<void> getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    setState(() {
      uid = user!.uid;
    });
  }

  String token = "";
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffe3eaef),
        body: StreamBuilder<QuerySnapshot>(
          stream: dataSnapshot
              .collection("demands")
              .where("owner", isEqualTo: uid)
              .where("state", isEqualTo: -1)
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.20,
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: [
                              IconSlideAction(
                                onTap: () {
                                  Slidable.of(context)?.renderingMode ==
                                          SlidableRenderingMode.none
                                      ? Slidable.of(context)?.open()
                                      : Slidable.of(context)?.close();
                                },
                                caption: "Annuler",
                                icon: Icons.close,
                                color: Colors.red,
                              ),
                              IconSlideAction(
                                caption: "Supprimer",
                                icon: Icons.delete,
                                color: Colors.green,
                                onTap: () {
                                  snapshot.data!.docs[index].reference.delete();
                                },
                              )
                            ],
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Nom de document : ${snapshot.data!.docs[index].get("name")}",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          "Classe : ${snapshot.data!.docs[index].get("classe")}",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          "Nombre de copie : ${snapshot.data!.docs[index].get("number")}",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                        Text(
                                          "Date de tirage : ${DateFormat("yyyy-MM-dd").format(snapshot.data!.docs[index].get("date").toDate())}",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Stack(
                                      children: [
                                        Image.asset("assets/images/pdf.png"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              print(snapshot.data);
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            Get.to(AddDemand(
              uid: uid,
            ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
