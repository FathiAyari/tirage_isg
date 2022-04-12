import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirage_isg/profile/components/profile_menu.dart';

import 'alertLogOut.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  var user = GetStorage().read("user");
  var mode = GetStorage();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffe3eaef),
        body: Column(
          children: [
            Container(
              child: Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/logo.jpg",
                          fit: BoxFit.fill,
                        )),
                  ),
                  Positioned(
                    bottom: -75,
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.orangeAccent,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage("${user['url']}"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  StringUtils.capitalize(" ${user['name']}"),
                  style: TextStyle(
                      color: Colors.blueAccent, fontSize: size.height * 0.03),
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
                Text(
                  StringUtils.capitalize(" ${user['lastname']}"),
                  style: TextStyle(
                      color: Colors.blueAccent, fontSize: size.height * 0.03),
                ),
              ],
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
            /*  GetBuilder<ThemeController>(
                init: ThemeController(),
                builder: (controller) {
                  return Padding(
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
                                inactiveTrackColor:
                                    Colors.amber.withOpacity(0.5),
                                inactiveThumbImage:
                                    AssetImage("assets/images/day.png"),
                                activeColor: Colors.black.withOpacity(0.1),
                                activeThumbImage:
                                    AssetImage("assets/images/night.png"),
                                value: controller.isDark,
                                onChanged: (value) {
                                  controller.updateTheme(value);
                                }),
                          )
                        ],
                      ),
                    ),
                  );
                })*/
          ],
        ),
      ),
    );
  }
}
