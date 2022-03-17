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
      'url': user.Url
    });
  }

  RememberResponsable(Cusers user) {
    var storage = GetStorage();
    token(1);
    storage.write("user", {
      'email': user.Email,
      'name': user.Name,
      'lastname': user.LastName,
      'url': user.Url
    });
  }

  token(int index) {
    var storage = GetStorage();
    storage.write("auth", 1);
    storage.write("type_auth", index);
  }

  Logout() {
    var storage = GetStorage();
    storage.write("auth", 0);
  }

  check() {
    var seen = GetStorage();
    seen.write("seen", 1);
  }
}
