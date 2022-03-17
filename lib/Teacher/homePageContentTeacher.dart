import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'components/demands/done_demands.dart';
import 'components/demands/my_demands.dart';
import 'components/demands/pending_demands.dart';

class homePageContentTeacher extends StatefulWidget {
  const homePageContentTeacher({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<homePageContentTeacher>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<Color> colors = [
    Color(0xffFF6A88),
    Color(0xffebd834),
    Color(0xff08c99c)
  ];
  int color = 0;
  var user = GetStorage().read("user");
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {
          color = _tabController.index;
        });
      });
  }

  var mode = GetStorage().read("mode");
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mode == true ? null : Color(0xffe3eaef),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.04,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage("${user['url']}"),
                        radius: 35,
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Text(
                        StringUtils.capitalize("Bonjour"),
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontFamily: "NewsCycle-Bold"),
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Text(
                        StringUtils.capitalize(" ${user['name']}"),
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontFamily: "NewsCycle-Bold"),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/teacher.png",
                    height: size.height * 0.07,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Container(
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.blueAccent,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colors[color],
                  ),
                  controller: _tabController,
                  tabs: [
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text("Mes demandes")),
                    Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(" En attente")),
                    Container(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(" Terminées ")),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [My_demands(), Pendingdemands(), DoneDemands()],
            ))
          ],
        ),
      ),
    );
  }
}
