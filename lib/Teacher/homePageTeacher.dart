import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../profile/profile_screen.dart';
import 'homePageContentTeacher.dart';

class homePageTeacher extends StatefulWidget {
  const homePageTeacher({Key? key}) : super(key: key);

  @override
  _homePageTeacherState createState() => _homePageTeacherState();
}

class _homePageTeacherState extends State<homePageTeacher> {
  getMessage() {
    print("het");
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.body);
      print(message.data);
      Get.snackbar(
        "Tirage ISG",
        "${message.notification!.body}",
        icon: Icon(Icons.person, color: Colors.white),
        backgroundColor: Colors.green.withOpacity(0.5),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessage();
  }

  var currentIndex = 0;
  List pages = [homePageContentTeacher(), ProfileScreen()];
  List<BottomNavyBarItem> items = [
    BottomNavyBarItem(
      icon: Icon(Icons.home_outlined),
      title: Text("Acceuil"),
      activeColor: Colors.blueAccent,
    ),
    BottomNavyBarItem(
      icon: SvgPicture.asset(
        "assets/images/user.svg",
        color: Color(0xFFFF7643),
      ),
      activeColor: Color(0xFFFF7643),
      title: const Text("Profil"),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[currentIndex],
        bottomNavigationBar:
            Container(decoration: BoxDecoration(), child: buildNavigationBar()),
      ),
    );
  }

  Container buildNavigationBar() {
    return Container(
      color: Color(0xffe3eaef),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.symmetric(horizontal: 70),
          child: BottomNavyBar(
            onItemSelected: (int value) {
              setState(() {
                currentIndex = value;
              });
            },
            selectedIndex: currentIndex,
            itemCornerRadius: 20,
            items: items,
            backgroundColor: Colors.transparent,
            showElevation: false,
          ),
        ),
      ),
    );
  }
}
