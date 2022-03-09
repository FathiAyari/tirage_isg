import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:tirage_isg/SignIn/ActionButton.dart';
import 'package:tirage_isg/SignIn/emailFormField.dart';
import 'package:tirage_isg/SignIn/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool check;

  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
                          icon: Icon(Icons.arrow_back_ios)),
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
              emailFormField(
                size: size,
                controller: emailController,
                prefixIcon: Icons.email_outlined,
              ),
              BuildLoginButton(size, "Recuperer votre mot de passe", () async {
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
