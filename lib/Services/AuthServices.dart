import 'package:firebase_auth/firebase_auth.dart';

import '../Models/Users.dart';
import 'DbServices.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
// creation d'instance de firebase auth
  //Authentification => instance firebaseAuth
  // base de donnée => instance firestore
  // stockage => instance  firestorage
  Future<bool> signIn(String emailController, String passwordController) async {
    try {
      // try => jarreb el code hedha
      // await => yestana lin tekml el tache => order pour attendre la fin de tache
      // await ma t5dem kan m3a el async
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
      //etape 1 : creation de compte
      await auth.createUserWithEmailAndPassword(
          email: emailController, password: passwordController);

      //etape 2: enregistrement de l'utilisateur dans le firestore
      await DbServices().saveUser(Cusers(
          uid: user!.uid,
          Name: Name,
          LastName: LastName,
          Email: emailController,
          Role: Role,
          Url: urlController)); // à travers le formulaire

      return true;
    } on FirebaseException catch (e) {
      print(e);
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

  User? get user => auth.currentUser; //pour recuperer l'utilisateur courant
}
