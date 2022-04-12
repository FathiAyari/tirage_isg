import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Models/Users.dart';

class RememberController extends GetxController {
  RememberTeacher(Cusers user) {
    var storage = GetStorage();
    token(2);
    storage.write("user", {
      'email': user.Email,
      'name': user.Name,
      'lastname': user.LastName,
      'url': user.Url,
      'id': user.uid
    });
  }

  RememberResponsable(Cusers user) {
    var storage = GetStorage();
    token(1);
    storage.write("user", {
      'email': user.Email,
      'name': user.Name,
      'lastname': user.LastName,
      'url': user.Url,
      'id': user.uid
    });
  }

  token(int index) {
    var storage = GetStorage();
    storage.write("auth", 1); // fama chkon 3mal login :)
    storage.write("type_auth", index);
  }

  Logout(String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"token": FieldValue.delete()});
    var storage = GetStorage();
    storage.write("auth", 0);
  }

  check() {
    var storage = GetStorage();
    storage.write("seen", 1);
  }
}
