import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''), // Spanish, no country code
      ],
      locale: Locale('fr'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      /* themeMode: sto.read("mode") == true ? ThemeMode.dark : ThemeMode.light,*/
      title: 'Tirage ISG',
      home: SplasScreen(),
    );
  }
}
