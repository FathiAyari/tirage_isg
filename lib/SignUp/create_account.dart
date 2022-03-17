import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tirage_isg/Services/AuthServices.dart';
import 'package:tirage_isg/SignIn/components/alert_failed.dart';
import 'package:tirage_isg/constants.dart';

import '../SignIn/ActionButton.dart';
import '../SignIn/DividerBox.dart';
import '../SignIn/FormFieldPassword.dart';
import '../SignIn/emailFormField.dart';
import '../SignIn/sign_in.dart';
import 'components/nameFormField.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String role = "choisir le type";

  final _formKey = GlobalKey<FormState>();
  Widget SuffixPassword = Icon(Icons.visibility);
  bool obscureText = true;
  Object val = "test";
  bool loading = false;
  File? _image;
  bool check = false;
  String extension = "";
  FirebaseAuth auth = FirebaseAuth.instance;
  Future getProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    final imageTemporary = File(image!.path);
    setState(() {
      _image = imageTemporary;
      check = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white24,
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
                        width: size.width * 0.25,
                      ),
                      Text(
                        ConstStrings.CreateAccount,
                        style: TextStyle(
                            fontSize: size.height * 0.028,
                            fontFamily: "NewsCycle-Bold"),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white38,
                              radius: 80,
                              backgroundImage: _image == null
                                  ? AssetImage('assets/images/user.png')
                                      as ImageProvider
                                  : FileImage(_image!),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  bottom: 10, end: 2),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: IconButton(
                                    onPressed: () {
                                      getProfileImage();
                                    },
                                    icon: Icon(
                                      Icons.add_photo_alternate_sharp,
                                      color: Colors.blueAccent,
                                      size: size.height * 0.05,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        DividerBox(
                          size: size,
                          height: 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              child: check == false
                                  ? Row(
                                      children: const [
                                        Text("Image pas encore selectionnée"),
                                        Icon(
                                          Icons.dangerous_outlined,
                                          color: Colors.red,
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: const [
                                        Text("Image bien selectionnée"),
                                        Icon(
                                          Icons.done_all,
                                          color: Colors.green,
                                        )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                        DividerBox(
                          size: size,
                          height: 0.02,
                        ),
                        Column(
                          children: [
                            nameFormField(
                              size: size,
                              controller: usernameController,
                              preixIcon: Icons.account_circle_sharp,
                              hintText: "Nom",
                            ),
                            nameFormField(
                              size: size,
                              controller: lastnameController,
                              preixIcon: Icons.account_circle_sharp,
                              hintText: "Prenom",
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
                                color: obscureText
                                    ? Colors.blueAccent
                                    : Colors.white,
                                onPressed: () {
                                  setState(() {
                                    this.obscureText = !obscureText;
                                  });
                                },
                              ),
                            ),
                            Container(
                              height: 60,
                              width: size.width * 0.7,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white10,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                  hint: Text(
                                    "${role}",
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  items: <String>[
                                    'enseignant(e)',
                                    'Responsable de tirage'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      role = value.toString();
                                    });
                                  },
                                )),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            !loading
                                ? BuildLoginButton(size, "Créer un compte",
                                    () async {
                                    if (role != "choisir le type") {
                                      if (_formKey.currentState!.validate() &&
                                          _image != null) {
                                        setState(() {
                                          loading = true;
                                        });
                                        var image = FirebaseStorage.instance
                                            .ref(_image!.path);
                                        var task = image.putFile(_image!);
                                        var imageurl = await (await task)
                                            .ref
                                            .getDownloadURL();
                                        bool check = await AuthServices()
                                            .signUp(
                                                emailController.text,
                                                passwordController.text,
                                                usernameController.text,
                                                lastnameController.text,
                                                imageurl.toString(),
                                                role);
                                        alertTask(
                                          lottieFile:
                                              "assets/images/success.json",
                                          action: "Connecter",
                                          message:
                                              "Votre compte a été créé avec succès",
                                          press: () {
                                            Get.to(() => SignIn());
                                          },
                                        ).show(context);
                                      }
                                    } else {
                                      Get.rawSnackbar(
                                        titleText: Text(
                                          "Tirage ISG",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        messageText: Text(
                                          "Choisir votre role svp",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor:
                                            Colors.green.withOpacity(0.5),
                                        borderRadius: 12,
                                        icon: Icon(Icons.done_all,
                                            color: Colors.white),
                                        margin: EdgeInsets.all(7),
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  })
                                : CircularProgressIndicator.adaptive(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
