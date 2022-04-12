import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tirage_isg/Services/AuthServices.dart';
import 'package:tirage_isg/SignIn/ActionButton.dart';
import 'package:tirage_isg/SignIn/emailFormField.dart';
import 'package:tirage_isg/SignIn/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool check = false;
// creation de controller pour un champ de text
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity, // taille de l'ecran width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white30,
                Colors.blueGrey,
              ],
            ),
          ),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.to(() => SignIn());
                          },
                          icon: Icon(Icons
                              .arrow_back_ios)), // espace vide entre deux widgets
                      SizedBox(
                        width: size.width * 0.15,
                      ),
                      Text(
                        "Mot de passe oubliée",
                        style: TextStyle(
                            fontSize: size.height * 0.028,
                            fontFamily: "NewsCycle-Bold"),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 100, horizontal: 10),
                child: Container(
                  child: Text(
                    "Entrer votre E-mail et vous recevrez un e-mail de récupération",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey, // clé de formulaire
                child: emailFormField(
                  size: size,
                  controller: emailController,
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : BuildLoginButton(size, "Recuperer votre mot de passe",
                      () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                        bool check = await AuthServices()
                            .resetPassword("${emailController.text}");
                        // future delayed pour attednre un peu de temps

                        if (check) {
                          Get.rawSnackbar(
                            titleText: Text(
                              "Tirage ISG",
                              style: TextStyle(color: Colors.white),
                            ),
                            messageText: Text(
                              "Consultez votre courrier électronique",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green.withOpacity(0.5),
                            borderRadius: 12,
                            icon: Icon(Icons.done_all, color: Colors.white),
                            margin: EdgeInsets.all(7),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        } else {
                          Get.rawSnackbar(
                            titleText: Text(
                              "Tirage ISG",
                              style: TextStyle(color: Colors.white),
                            ),
                            messageText: Text(
                              "email  correspond  a aucune utilisateur ",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red.withOpacity(0.5),
                            borderRadius: 12,
                            icon: Icon(Icons.error, color: Colors.red),
                            margin: EdgeInsets.all(7),
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                        // snackbar pour afficher un message
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
