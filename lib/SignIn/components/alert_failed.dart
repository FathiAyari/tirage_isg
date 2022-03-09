import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tirage_isg/onboardingPage/remember_controller.dart';

class alertFailed extends StatelessWidget {
  final String message;
  final Function press;

  alertFailed({this.message, this.press});
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
                      height: 150,
                      width: size.width * 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "pas de compte avec ces cordonnées ",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(15),
                              ),
                              onPressed: press,
                              child: Text("Ressayer")),
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
