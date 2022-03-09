import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:tirage_isg/ForgotPassword/ForgotPassword.dart';

import 'ActionButton.dart';
import 'DividerBox.dart';
import 'FormFieldPassword.dart';
import 'components/alert_choose_type.dart';
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
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(" Non"));
  }

  bool hasConnection = false;
  bool loading = false;
  bool obscureText = true;
  Widget SuffixPassword = Icon(Icons.visibility);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String verifyInput() {
    String result = "";

    if (emailController.text.isEmpty || !validateEmail(emailController.text)) {
      result += "Veuillez verifier l'email";
    } else if (passwordController.text.isEmpty) {
      result += "Veuillez verifier le mot de passe ";
    }
    return result;
  }

  @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text(" êtes-vous sûr de sortir ?"),
                actions: [Negative(context), Positive()],
              );
            });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                Spacer(),
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
                    ? BuildLoginButton(size, "Connecter", () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                        }
                        ;
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
                            alertChooseType().show(context);
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

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
