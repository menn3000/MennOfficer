// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mennofficer/widgets/widget_image.dart';
import 'package:mennofficer/widgets/widget_listtile.dart';
import 'package:mennofficer/widgets/widget_text_button.dart';

class MyDialog {
  final BuildContext context;
  MyDialog({
    required this.context,
  });

  void normalDialog({
    required String title,
    required String subTitle,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: WidgetListTile(
            leadWidget: const SizedBox(
              width: 80,
              child: WidgetImage(),
            ),
            title: title,
            subTitle: subTitle),
        actions: [
          WidgetTextButton(
            label: 'OK',
            pressFunc: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      barrierDismissible: false,
    );
  }
}
