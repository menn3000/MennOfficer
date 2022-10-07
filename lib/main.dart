import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mennofficer/states/authen.dart';
import 'package:mennofficer/states/main_boss.dart';
import 'package:mennofficer/states/main_officer.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (context) => const Authen(),
  MyConstant.routeBoss: (context) => const MainBoss(),
  MyConstant.routeoOfficer: (context) => const MainOfficer(),
};

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
// make sure thread done first before other function
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var result = preferences.getStringList('data');
  print('result main = $result');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: MyConstant.routeAuthen,
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
