import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tirage_isg/splashScreen/splash_screen.dart';

var sto = GetStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //
  await Firebase.initializeApp(); //
  await GetStorage.init(); //
  await FlutterDownloader.initialize(debug: true);
  runApp(MyApp()); //
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: sto.read("mode") == true ? ThemeMode.dark : ThemeMode.light,
      title: 'Tirage ISG',
      home: SplasScreen(),
    );
  }
}

/*class test extends StatelessWidget {
  const test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30))), // style de ElevatedButton
            onPressed: () {
              print("bonjour");
            },
            child: Text(
              " click",
            ),
          ),
        ),
      ),
    ));
  }
}

class test2 extends StatefulWidget {
  const test2({Key? key}) : super(key: key);

  @override
  _test2State createState() => _test2State();
}

class _test2State extends State<test2> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("compteur : ${i} "), //interpolation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30))), // style de ElevatedButton
                    onPressed: () {
                      setState(() {
                        i++;
                      });
                    },
                    child: Text(
                      " Ajouter + ",
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30))), // style de ElevatedButton
                    onPressed: () {
                      setState(() {
                        i--;
                      });
                    },
                    child: Text(
                      "Reduire - ",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}*/
