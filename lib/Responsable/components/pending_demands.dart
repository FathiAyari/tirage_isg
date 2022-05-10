import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

//responsable
var dataSnapshot = FirebaseFirestore.instance;

class Pendingdemands extends StatefulWidget {
  const Pendingdemands({Key? key}) : super(key: key);

  @override
  _PendingdemandsState createState() => _PendingdemandsState();
}

class _PendingdemandsState extends State<Pendingdemands> {
  var user = GetStorage().read("user");
  List tokens = [];
  sendNotfiy(String title, String body, String token) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          "Content-Type": 'application/json',
          'Authorization':
              'key=	AAAADaIyKvE:APA91bFlG2mxQytjkC2nD9fAvt62LrDMcnC9HwYlh-rzKOmUsjMw04ihq1Co-JJlZgr1rYgGqcPw4c6HaNmwen7h80JuoTY0avaynAhINXE2OL2yJ2XRCNCbxwMOWyIuTp_MQS__hLUv',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              "body": body.toString(),
              'title': title.toString()
            },
            "priority": "high",
            "data": <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': token
          },
        ));
  }

  getMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3eaef),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataSnapshot
            .collection("demands")
            .where("state", isEqualTo: 0)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: dataSnapshot
                            .collection("users")
                            .where("uid",
                                isEqualTo:
                                    snapshot.data!.docs[index].get("owner"))
                            .snapshots(),
                        builder: (context, snapshotUserData) {
                          if (snapshotUserData.hasData) {
                            return Container(
                              height: size.height * 0.20,
                              decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                                Text(
                                                  "L'ensengaient(e) : ${snapshotUserData.data!.docs[0].get("name")} ${snapshotUserData.data!.docs[0].get("lastname")}",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Lottie.asset(
                                              "assets/images/swip3.json",
                                              height: 50,
                                              repeat: false),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                      caption: "Terminer",
                                      icon: Icons.done_outline,
                                      color: Colors.green,
                                      onTap: () async {
                                        await snapshot
                                            .data!.docs[index].reference
                                            .update({"state": 1});
                                        Fluttertoast.showToast(
                                          msg: "Element terminé ",
                                          backgroundColor: Colors.grey,
                                          // fontSize: 25
                                          // gravity: ToastGravity.TOP,
                                          // textColor: Colors.pink
                                        );
                                        sendNotfiy(
                                            "Service du tirage ISG",
                                            "Notre cher (chère) ensengaient(e)  votre demande  d'impression ${snapshot.data!.docs[index].get("name")} est prête au bureau de responsable :  ${user["lastname"]} ${user["name"]}.",
                                            snapshotUserData.data!.docs[0]
                                                .get("token"));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text("");
                          }
                        }),
                  );
                });
          } else {
            print(snapshot.data);
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
