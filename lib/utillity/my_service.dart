// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mennofficer/utillity/my_dialog.dart';
import 'package:mennofficer/widgets/widget_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService {
  Future<Position?> processFindPosition({required BuildContext context}) async {
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    LocationPermission locationPermission = await Geolocator.checkPermission();
    Position? position;

    if (locationServiceEnable) {
      print('Location service is on');

      if (locationPermission == LocationPermission.deniedForever) {
        locationDialog(context,
            title: 'Permission is Denied forever',
            subTitle: 'Please allow permission for this app as always',
            actionFunc: () {
          Geolocator.openAppSettings();
          exit(0);
        });
      } else {
        if (locationPermission == LocationPermission.denied) {
          // Denied Status
          locationPermission = await Geolocator.requestPermission();

          if ((locationPermission != LocationPermission.always) &&
              (locationPermission != LocationPermission.whileInUse)) {
            //Denied Forever
            locationDialog(context,
                title: 'Permission is Denied forever',
                subTitle: 'Please allow permission for this app as always',
                actionFunc: () {
              Geolocator.openAppSettings();
              exit(0);
            });
          } else {
            //Alway , WhileInUse
            position = await Geolocator.getCurrentPosition();
          }
        } else {
          //Alway , WhileInUse
          position = await Geolocator.getCurrentPosition();
        }
      }
    } else {
      print('Location service is off');
      locationDialog(context, actionFunc: () {
        Geolocator.openLocationSettings();
        exit(0);
      },
          title: 'Location service is off ?',
          subTitle: 'Please turn on location service.');
    }
    return position;
  }

  void locationDialog(
    BuildContext context, {
    required String title,
    required String subTitle,
    required Function() actionFunc,
  }) {
    MyDialog(context: context).normalDialog(
        title: title,
        subTitle: subTitle,
        textButtonWidget: WidgetTextButton(
          label: 'Open service and Exit',
          pressFunc: actionFunc,
        ));
  }

  Future<List<String>> findDatas() async {
    var results = <String>[];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    results = preferences.getStringList('data')!;

    return results;
  }
}
