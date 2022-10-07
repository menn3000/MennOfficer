// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class WidgetButton extends StatelessWidget {
  final String lable;
  final Function() pressFunc;

  const WidgetButton({
    Key? key,
    required this.lable,
    required this.pressFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: pressFunc,
      child: WidgetText(
        text: lable,
        textStyle: MyConstant().h3AButtonStyle(),
      ),
    );
  }
}
