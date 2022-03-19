import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//teacher
var dataSnapshot = FirebaseFirestore.instance;

class DoneDemands extends StatefulWidget {
  const DoneDemands({Key? key}) : super(key: key);

  @override
  _DoneDemandsState createState() => _DoneDemandsState();
}

class _DoneDemandsState extends State<DoneDemands> {
  late String uid;
  Future<void> getUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    setState(() {
      uid = user!.uid;
    });
  }

  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: dataSnapshot
            .collection("demands")
            .where("state", isEqualTo: 1)
            .where("owner", isEqualTo: uid)
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
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                                  ],
                                ),
                              ),
                              Image.asset(
                                "assets/images/done.png",
                                height: 30,
                              )
                            ],
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
    );
  }
}
