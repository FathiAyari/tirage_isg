import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:tirage_isg/SignIn/sign_in.dart';
import 'package:tirage_isg/onboardingPage/remember_controller.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var OnBoardingController = RememberController();
  int currentPage = 0;
  List<Widget> pages = [
    OnbaordingContent(
      title: "Bienvenue ",
      desc:
          ' Vous êtes un(e) enseignant(e) ou bien responsable de tirage ? vous etes  au bon endroit .',
      image: 'assets/images/welcome.json',
    ),
    OnbaordingContent(
      title:
          "êtes-vous fatigué d'amener les documents chaque jour au service de tirage  ?",
      desc: 'Tirage ISG est la meilleur solution  pour vous ',
      image: 'assets/images/question.json',
    ),
    OnbaordingContent(
      title: "Avec Tirage ISG",
      desc:
          'A partir de maintenant deposer vos documents au service de tirage par un seul clic ',
      image: 'assets/images/done.json',
    ),
  ];
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemCount: pages.length,
              scrollDirection: Axis.horizontal, // the axis
              controller: _controller,
              itemBuilder: (context, int index) {
                return pages[index];
              }),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (int index) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: size.height * 0.01,
                    width: (index == currentPage)
                        ? 25
                        : 10, // condition au lieu de if else
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (index == currentPage)
                            ? Colors.blue
                            : Colors.blue.withOpacity(0.5)),
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                        onTap: () async {
                          OnBoardingController.check();
                          Get.to(() => SignIn());
                        },
                        child: Text(
                          'Ignorer',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 40,
                      width: (currentPage == pages.length - 1) ? 150 : 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: (currentPage == pages.length - 1)
                            ? Text("Commencer")
                            : Text("Suivant"),
                        onPressed: (currentPage == pages.length - 1)
                            ? () {
                                OnBoardingController.check();
                                Get.to(() => SignIn());
                              }
                            : () {
                                OnBoardingController.check();
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOutQuint);
                              },
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class OnbaordingContent extends StatelessWidget {
  final String title;
  final String image;
  final String desc;
  const OnbaordingContent({
    required this.title,
    required this.image,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 5),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.orange, fontSize: size.height * 0.03)),
            ),
            Lottie.asset(
              image,
              repeat: true,
              height: size.height * 0.4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontFamily: 'NewsCycle-Bold'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
