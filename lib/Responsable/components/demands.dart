import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

//responsable
var dataSnapshot = FirebaseFirestore.instance;

class Demands extends StatefulWidget {
  const Demands({Key? key}) : super(key: key);

  @override
  _InProgressState createState() => _InProgressState();
}

class _InProgressState extends State<Demands> {
  ReceivePort _port = ReceivePort();

  sendNotfiy(String title, String body) async {
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
            'to': await FirebaseMessaging.instance.getToken()
          },
        ));
  }

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');

    send!.send([id, status, progress]);
    Text("$progress");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dataSnapshot
            .collection("demands")
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
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nom de document : ${snapshot.data!.docs[index].get("name")}",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: dataSnapshot
                                          .collection("users")
                                          .where("uid",
                                              isEqualTo: snapshot
                                                  .data!.docs[index]
                                                  .get("owner"))
                                          .snapshots(),
                                      builder: (context, snapshotUserData) {
                                        if (snapshotUserData.hasData) {
                                          return Text(
                                            "L'ensengaient(e) : ${snapshotUserData.data!.docs[0].get("name")} ${snapshotUserData.data!.docs[0].get("lastname")}",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                            ),
                                          );
                                        } else {
                                          return Text("");
                                        }
                                      })
                                ],
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                splashColor: Color(0xffe3eaef),
                                highlightColor: Color(0xffe3eaef),
                                onTap: () async {
                                  var test = snapshot.data!.docs[index]
                                      .get("url")
                                      .toString()
                                      .split("file_picker%2F")[1];
                                  print(
                                      "---${test.split("pdf")[0].replaceAll("%20", " ")}---");
                                  var status =
                                      await Permission.storage.request();
                                  if (status.isGranted) {
                                    final baseStorage =
                                        await getExternalStorageDirectory();
                                    await FlutterDownloader.enqueue(
                                      url:
                                          '${snapshot.data!.docs[index].get("url")}',
                                      fileName: test
                                              .split("pdf")[0]
                                              .replaceAll("%20", " ") +
                                          "pdf",

                                      showNotification:
                                          true, // show download progress in status bar (for Android)
                                      openFileFromNotification: true,
                                      savedDir: baseStorage!
                                          .path, // click on notification to open downloaded file (for Android)
                                    );
                                    await snapshot.data!.docs[index].reference
                                        .update({"state": 0});
                                    Fluttertoast.showToast(
                                      msg:
                                          "Element telechargé et  ajouté à la liste d'attente",
                                      backgroundColor: Colors.grey,
                                      // fontSize: 25
                                      // gravity: ToastGravity.TOP,
                                      // textColor: Colors.pink
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Image.asset("assets/images/pdf.png"),
                                    Image.asset(
                                      "assets/images/download.png",
                                      height: 25,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
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
    );
  }
}
