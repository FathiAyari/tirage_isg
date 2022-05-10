import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:tirage_isg/ForgotPassword/ForgotPassword.dart';
import 'package:tirage_isg/Responsable/homePagResponsable.dart';
import 'package:tirage_isg/Services/AuthServices.dart';
import 'package:tirage_isg/Teacher/homePageTeacher.dart';

import '../Models/Users.dart';
import '../SignUp/create_account.dart';
import '../onboardingPage/remember_controller.dart';
import 'ActionButton.dart';
import 'DividerBox.dart';
import 'FormFieldPassword.dart';
import 'components/alert_failed.dart';
import 'emailFormField.dart';

class SignIn extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<SignIn> {
  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  } // fermeture de l'application

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  bool hasConnection = false;
  bool loading = false;
  late String token;
  bool obscureText = true;
  final controller = RememberController();
  Widget SuffixPassword = Icon(Icons.visibility);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<bool> avoidReturnButton() async {
    // async pour l'ouverture de thread
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(" êtes-vous sûr de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getToken().then((userToken) {
      setState(() {
        token = userToken!;
        print(token);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        // eviter le retour de button
        onWillPop: avoidReturnButton,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blueGrey,
                  Colors.white24,
                ],
              ),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DividerBox(
                        size: size,
                        height: 0.08,
                      ),
                      emailFormField(
                        size: size,
                        controller: emailController,
                        prefixIcon: Icons.email_outlined,
                      ),
                      FormFieldPassword(
                        size: size,
                        controller: passwordController,
                        preixIcon: Icons.lock_outline,
                        obscuretext: obscureText,
                        suffixIcon: IconButton(
                          icon: obscureText
                              ? SuffixPassword
                              : Icon(Icons.visibility_off),
                          color: obscureText ? Colors.blueAccent : Colors.white,
                          onPressed: () {
                            setState(() {
                              this.obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 45),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: const Text("Mot de passe oublié ?",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                          )),
                      onTap: () {
                        Get.to(() => ForgotPassword());
                      },
                    ),
                  ),
                ),
                !loading
                    ? BuildLoginButton(size, "Connecter", () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          Future check = AuthServices().signIn(
                              emailController.text, passwordController.text);

                          check.then((value) async {
                            if (value) {
                              final FirebaseAuth auth =
                                  await FirebaseAuth.instance;
                              final User? user = await auth.currentUser;
                              final uid = user!.uid;
                              var UserData = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .get();

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .update({
                                "token": token
                              }); // token pour la notification
                              if (UserData["role"] == "Responsable de tirage") {
                                // test de role
                                await controller.RememberResponsable(
                                    Cusers.fromJson(UserData
                                        .data())); //.data() pour recuperer le donneées de document
                                Get.to(homePageResponsable());
                              } else {
                                await controller.RememberTeacher(
                                    Cusers.fromJson(UserData.data()));
                                Get.to(homePageTeacher());
                              }
                            } else {
                              alertTask(
                                lottieFile: "assets/images/error.json",
                                action: "Ressayer",
                                message: "pas de compte avec ces cordonnées ",
                                press: () {
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pop(context);
                                },
                              ).show(context);
                            }
                          });
                        }
                      })
                    : CircularProgressIndicator.adaptive(),
                SizedBox(
                  height: size.height * 0.25,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Tu n'es pas inscrit ?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "Tajawal"),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => CreateAccount());
                          },
                          child: const Text(
                            " Créer un compte ",
                            style: TextStyle(
                                color: Color(0xFFFF7643),
                                fontSize: 20,
                                fontFamily: "Tajawal"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
