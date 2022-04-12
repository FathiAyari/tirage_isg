import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
//teacher

var dataSnapshot = FirebaseFirestore.instance;

class My_demands extends StatefulWidget {
  const My_demands({Key? key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<My_demands> {
  TextEditingController docName = TextEditingController();
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

  void createAlert(BuildContext context, Size size, String uid) {
    var isLoading = false;
    var hideContent = false;
    showDialog(
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xffe3eaef),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        height: size.height * 0.3,
                        child: hideContent
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/images/success.json",
                                      repeat: false, height: size.height * 0.2),
                                  Text(" Envoyé avec success"),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: EdgeInsets.all(15),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Sortir")),
                                ],
                              )
                            : (isLoading
                                ? Lottie.asset("assets/images/load.json",
                                    height: size.height * 0.1)
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/images/printer.png",
                                        height: size.height * 0.04,
                                      ),
                                      const Text("Demande  d'impression"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: TextFormField(
                                          controller: docName,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              hintText: "Nom de document",
                                              hintStyle: const TextStyle(
                                                color: Colors.blueAccent,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.print,
                                                color: Colors.blueAccent,
                                              ),
                                              fillColor: Colors
                                                  .white10, // the color of the inside box field
                                              filled: true,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10), //borderradius
                                              )),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          result = (await FilePicker.platform
                                              .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: ['pdf']))!;
                                        },
                                        icon: Icon(Icons.add),
                                        label: Text("Ajouter un fichier"),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.all(15),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Annuler")),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                padding: EdgeInsets.all(15),
                                              ),
                                              onPressed: () async {
                                                if (result != null &&
                                                    result.files.single
                                                            .extension ==
                                                        "pdf") {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  String? uploadFile =
                                                      result.files.single.path;
                                                  setState(() {
                                                    pdfFile = File(result
                                                        .files.single.path!);
                                                    print(pdfFile);
                                                  });
                                                  Reference reference =
                                                      await FirebaseStorage
                                                          .instance
                                                          .ref()
                                                          .child(pdfFile!.path);
                                                  print(reference);

                                                  final UploadTask uploadTask =
                                                      reference
                                                          .putFile(pdfFile!);

                                                  uploadTask
                                                      .whenComplete(() async {
                                                    var imageUpload =
                                                        await uploadTask
                                                            .snapshot.ref
                                                            .getDownloadURL();
                                                    var test = imageUpload
                                                        .split("pdf")[0];

                                                    var userCollection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'demands');

                                                    await userCollection
                                                        .doc()
                                                        .set({
                                                      "name": docName.text,
                                                      'time': FieldValue
                                                          .serverTimestamp(),
                                                      "state": -1,
                                                      "owner": uid,
                                                      "url": imageUpload
                                                              .split("pdf")[0] +
                                                          "pdf" +
                                                          imageUpload
                                                              .split("pdf")[1],
                                                    });
                                                    setState(() {
                                                      isLoading = false;
                                                      hideContent = true;
                                                    });
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "format de fichier doit être Pdf",
                                                    backgroundColor:
                                                        Colors.grey,
                                                    // fontSize: 25
                                                    // gravity: ToastGravity.TOP,
                                                    // textColor: Colors.pink
                                                  );
                                                }
                                              },
                                              child: Text("Confirmer")),
                                        ],
                                      ),
                                    ],
                                  )),
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            );
          });
        },
        context: context);
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
                        height: size.height * 0.15,
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
            createAlert(context, size, uid);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}
