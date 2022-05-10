import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AddDemand extends StatefulWidget {
  final String uid;
  const AddDemand({Key? key, required this.uid}) : super(key: key);

  @override
  _AddDemandState createState() => _AddDemandState();
}

class _AddDemandState extends State<AddDemand> {
  DateTime dateTime = DateTime.now();
  bool dateSelcted = false;
  var isLoading = false;
  var hideContent = false;
  File? pdfFile;
  TextEditingController docName = TextEditingController();
  TextEditingController classe = TextEditingController();
  TextEditingController number = TextEditingController();
  String pdfFileName = "cliquer pour choisir un pdf ";

  late FilePickerResult result;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Ajouter une demande",
          style: TextStyle(color: Colors.blueAccent),
        ),
        backgroundColor: Color(0xffe3eaef),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffe3eaef),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: size.height,
            child: hideContent
                ? Container(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/images/success.json",
                            repeat: false, height: size.height * 0.2),
                        Text(" Envoyé avec success"),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Sortir")),
                      ],
                    ),
                  )
                : (isLoading
                    ? Lottie.asset("assets/images/load.json",
                        height: size.height * 0.1)
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      borderRadius: BorderRadius.circular(
                                          10), //borderradius
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: TextFormField(
                                controller: classe,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Classe",
                                    hintStyle: const TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.school,
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
                            Container(
                              child: TextFormField(
                                controller: number,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Nombre de copie",
                                    hintStyle: const TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.format_list_numbered_sharp,
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
                            ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2033))
                                      .then((value) {
                                    setState(() {
                                      dateTime = value!;
                                      dateSelcted = true;
                                    });
                                  });
                                },
                                child: Text(dateSelcted
                                    ? "${DateFormat("yyyy-MM-dd").format(dateTime)}"
                                    : "Date")),
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
                                        setState(() {
                                          isLoading = true;
                                        });
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
                                                .child(pdfFile!.path);
                                        print(reference);

                                        final UploadTask uploadTask =
                                            reference.putFile(pdfFile!);

                                        uploadTask.whenComplete(() async {
                                          var imageUpload = await uploadTask
                                              .snapshot.ref
                                              .getDownloadURL();
                                          var test =
                                              imageUpload.split("pdf")[0];

                                          var userCollection = FirebaseFirestore
                                              .instance
                                              .collection('demands');

                                          await userCollection.doc().set({
                                            "name": docName.text,
                                            'time':
                                                FieldValue.serverTimestamp(),
                                            "state": -1,
                                            "owner": widget.uid,
                                            "classe": classe.text,
                                            "number": number.text,
                                            "date": dateTime,
                                            "url": imageUpload.split("pdf")[0] +
                                                "pdf" +
                                                imageUpload.split("pdf")[1],
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
                      )),
          ),
        ),
      ),
    ));
  }
}
