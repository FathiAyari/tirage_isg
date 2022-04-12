import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:tirage_isg/Responsable/homePagResponsable.dart';
import 'package:tirage_isg/SignIn/sign_in.dart';
import 'package:tirage_isg/Teacher/homePageTeacher.dart';
import 'package:tirage_isg/onboardingPage/Onboarding.dart';

class SplasScreen extends StatefulWidget {
  @override
  _SplasScreenState createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var auth = GetStorage().read("auth");

    var type_auth = GetStorage().read("type_auth");
    var resultSeen = GetStorage().read("seen");
    Timer(
        Duration(seconds: 4),
        () => Get.to(resultSeen == 1
            ? (auth == 1
                ? (type_auth == 1 ? homePageResponsable() : homePageTeacher())
                : SignIn())
            : Onboarding()));
  }

// Get.to(esm el page eli theb temchilha)
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: size.width * 0.9,
                  ),
                ),
                Container(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        "Service de tirage ISG",
                        textStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 40,
                          fontFamily: 'NewsCycle-Bold',
                        ),
                        speed: Duration(milliseconds: 40),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Lottie.asset(
                  "assets/images/loading.json",
                  height: size.height * 0.2,
                )
              ],
            ),
          ),
        ));
  }
}

/*
if(){
  if 3adiya
}else{}*/
/*
* inline if
*
* test==1?wa9t tkon condition valide  chniya ysir :wa9t el condition n'est pas valide
*
* */
