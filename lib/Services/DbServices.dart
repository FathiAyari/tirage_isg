import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/Users.dart';

class DbServices {
  var userCollection = FirebaseFirestore.instance.collection('users');

  saveUser(Cusers user) async {
    try {
      // .set(json ) pour ajouter des champs dans une document
      await userCollection
          .doc(user.uid)
          .set(user.Tojson()); // ajout d'utilisateur dans le document
    } catch (e) {}
  }
}
