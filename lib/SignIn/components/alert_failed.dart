import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tirage_isg/onboardingPage/remember_controller.dart';

class alertTask extends StatelessWidget {
  final String message;
  final String lottieFile;
  final String action;
  final void Function() press;

  alertTask(
      {required this.message,
      required this.press,
      required this.action,
      required this.lottieFile});
  final controller = RememberController();
  show(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xffe3eaef),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Container(
                      height: 200,
                      width: size.width * 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Lottie.asset(
                            lottieFile,
                            repeat: false,
                            height: size.height * 0.1,
                          ),
                          Text(
                            "${message}",
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                              ),
                              onPressed: press,
                              child: Text("${action}")),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material();
  }
}
