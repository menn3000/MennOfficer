import 'package:flutter/material.dart';

class MyConstant {
  //field
  static String routeAuthen = '/authen';
  static String routeoOfficer = '/officer';
  static String routeBoss = '/boss';

  static String appName = 'Menn Officer';
  static Color dark = const Color.fromARGB(255, 4, 3, 73);
  static Color primary = Color.fromARGB(255, 2, 47, 77);
  static Color active = const Color.fromARGB(255, 247, 18, 94);

  //Method

  BoxDecoration imageBox() {
    return const BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/bg.jpg'), fit: BoxFit.cover),
    );
  }

  BoxDecoration colorBox() {
    return BoxDecoration(
      color: primary.withOpacity(
        (0.25),
      ),
    );
  }

  BoxDecoration gradientBox() {
    return BoxDecoration(
      gradient: RadialGradient(
        radius: 1.0,
        center: Alignment.topLeft,
        colors: [Colors.white, primary],
      ),
    );
  }

  BoxDecoration whiteBox() {
    return BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(100), topRight: Radius.circular(100)));
  }

  TextStyle h1Style({Color? color}) {
    return TextStyle(
      fontSize: 36,
      color: color ?? dark,
      fontWeight: FontWeight.bold,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h2Style() {
    return TextStyle(
      fontSize: 24,
      color: dark,
      fontWeight: FontWeight.w700,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h3Style() {
    return TextStyle(
      fontSize: 15,
      color: dark,
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h3ActiveStyle() {
    return TextStyle(
      fontSize: 16,
      color: active,
      fontWeight: FontWeight.w500,
      fontFamily: 'Sarabun',
    );
  }

  TextStyle h3AButtonStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontFamily: 'Sarabun',
    );
  }
}
