import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//teacher
var dataSnapshot = FirebaseFirestore.instance;

class Pendingdemands extends StatefulWidget {
  const Pendingdemands({Key? key}) : super(key: key);

  @override
  _PendingdemandsState createState() => _PendingdemandsState();
}

class _PendingdemandsState extends State<Pendingdemands> {
  late String uid;
  Future<void> getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    setState(() {
      uid = user!.uid;
    });
  }

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
            .where("state", isEqualTo: 0)
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
                          color: Colors.amber.withOpacity(0.3),
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
