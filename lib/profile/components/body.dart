import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirage_isg/profile/components/theme_controller.dart';

import 'alertLogOut.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  final conotroller = Get.put(ThemeController());
  var user = GetStorage().read("user");
  var mode = GetStorage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage("${user['url']}"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    StringUtils.capitalize("${user["name"]} "),
                    style: TextStyle(
                        color: Colors.blueAccent, fontSize: size.height * 0.03),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Text(
                    StringUtils.capitalize("${user["lastname"]} "),
                    style: TextStyle(
                        color: Colors.blueAccent, fontSize: size.height * 0.03),
                  ),
                ],
              ),
            ),
            ProfileMenu(
              text: "Aide",
              icon: "assets/images/question.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Deconnexion",
              icon: "assets/images/log_out.svg",
              press: () {
                alertLogOut(
                  press: () {
                    Navigator.of(context).pop();
                  },
                ).show(context);
              },
            ),
            /*    Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Color(0xFFFF7643),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(child: Text("Mode nuit")),
                    Transform.scale(
                      scale: 1.8,
                      child: Switch(
                          inactiveTrackColor: Colors.amber.withOpacity(0.5),
                          inactiveThumbImage:
                              AssetImage("assets/images/day.png"),
                          activeColor: Colors.black.withOpacity(0.1),
                          activeThumbImage:
                              AssetImage("assets/images/night.png"),
                          value: mode.read("mode") == true ? true : false,
                          onChanged: (value) {
                            setState(() {
                              conotroller.updateTheme(value);
                            });
                          }),
                    )
                  ],
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
