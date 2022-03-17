import 'package:firebase_auth/firebase_auth.dart';

import '../Models/Users.dart';
import 'DbServices.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> signIn(String emailController, String passwordController) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController, password: passwordController);

      return true;
    } on FirebaseException catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String emailController, String passwordController,
      String Name, String LastName, String urlController, String Role) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);
      await DbServices().saveUser(Cusers(
          uid: user!.uid,
          Name: Name,
          LastName: LastName,
          Email: emailController,
          Role: Role,
          Url: urlController));

      return true;
    } on FirebaseException catch (e) {
      print("not ");
      return false;
    }
  }

  Future<bool> resetPassword(String emailController) async {
    try {
      await auth.sendPasswordResetEmail(email: emailController);
      return true;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }

  User? get user => auth.currentUser;
}
