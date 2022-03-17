import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AlertAddDemande extends StatefulWidget {
  final void Function() press;

  AlertAddDemande({required this.press});

  @override
  AlertAddDemandeState createState() => AlertAddDemandeState();
}

class AlertAddDemandeState extends State<AlertAddDemande> {
  TextEditingController docName = TextEditingController();
  String pdfFileName = "cliquer pour choisir un pdf ";
  late FilePickerResult result;
  File? pdfFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
  }

  @override
  show(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 10,
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
                                    Icons.check,
                                    color: Colors.blueAccent,
                                  ),
                                  fillColor: Colors
                                      .white10, // the color of the inside box field
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), //borderradius
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              result = (await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf']))!;
                            },
                            icon: Icon(Icons.add),
                            label: Text("Ajouter un fichier"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                                  child: Text("Annuler")),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    padding: EdgeInsets.all(15),
                                  ),
                                  onPressed: () async {
                                    if (result != null &&
                                        result.files.single.extension ==
                                            "pdf") {
                                      String? uploadFile =
                                          result.files.single.path;
                                      setState(() {
                                        pdfFile =
                                            File(result.files.single.path!);
                                        print(pdfFile);
                                      });
                                      Reference reference =
                                          await FirebaseStorage.instance
                                              .ref()
                                              .child(pdfFile.toString());
                                      print(reference);

                                      final UploadTask uploadTask =
                                          reference.putFile(pdfFile!);

                                      uploadTask.whenComplete(() async {
                                        var imageUpload = await uploadTask
                                            .snapshot.ref
                                            .getDownloadURL();
                                        var userCollection = FirebaseFirestore
                                            .instance
                                            .collection('demands');

                                        await userCollection.doc().set({
                                          "name": docName.text,
                                          "state": "-1",
                                          "owner": "sds",
                                          "url": imageUpload.toString(),
                                        });
                                        print(imageUpload);
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "format de fichier doit être Pdf",
                                        backgroundColor: Colors.grey,
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material();
  }
}
