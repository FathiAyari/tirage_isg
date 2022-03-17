import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//responsable

var dataSnapshot = FirebaseFirestore.instance;

class DoneDemands extends StatelessWidget {
  const DoneDemands({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3eaef),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataSnapshot
            .collection("demands")
            .where("state", isEqualTo: 1)
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
