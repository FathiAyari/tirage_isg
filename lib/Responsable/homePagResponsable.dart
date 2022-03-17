import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../profile/profile_screen.dart';
import 'homePageContentResponsable.dart';

class homePageResponsable extends StatefulWidget {
  @override
  _homePageResponsableState createState() => _homePageResponsableState();
}

class _homePageResponsableState extends State<homePageResponsable> {
  @override
  var currentIndex = 0;
  List pages = [homePageContentResponsable(), ProfileScreen()];
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
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Color(0xffe3eaef),
            ),
            child: buildNavigationBar()),
      ),
    );
  }

  Container buildNavigationBar() {
    return Container(
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
