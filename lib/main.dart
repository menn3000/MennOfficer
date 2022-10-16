// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mennofficer/states/authen.dart';
import 'package:mennofficer/states/authen_web.dart';
import 'package:mennofficer/states/main_boss.dart';
import 'package:mennofficer/states/main_officer.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
//for web
import 'package:flutter/foundation.dart' show kIsWeb;

Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (context) => const Authen(),
  MyConstant.routeBoss: (context) => const MainBoss(),
  MyConstant.routeoOfficer: (context) => const MainOfficer(),
  MyConstant.routeWeb: (context) => const AuthenWeb(),
};

String? firstState;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
// make sure thread done first before other function
  WidgetsFlutterBinding.ensureInitialized();

// for running on web
  if (kIsWeb) {
    //for Web
    firstState = MyConstant.routeWeb;
    runApp(const MyApp());
  } else {
    // for Mobile
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var result = preferences.getStringList('data');
    print('result main = $result');

    if (result != null) {
      var datas = <String>[];
      datas.addAll(result);
      switch (datas[1]) {
        case 'boss':
          firstState = MyConstant.routeBoss;
          break;
        case 'officer':
          firstState = MyConstant.routeoOfficer;
          break;
        default:
          firstState = MyConstant.routeAuthen;
          break;
      }
    } else {}

    await Firebase.initializeApp().then((value) {
      //must ini firebase for noti service
      runApp(const MyApp());
    });
  }
} // end Main

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState ?? MyConstant.routeAuthen,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: MyConstant.dark,
            elevation: 0),
      ),
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
