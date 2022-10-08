// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class WidgetListTile extends StatelessWidget {
  final Widget leadWidget;
  final String title;
  final String subTitle;
  final Function()? tabFunc;
  

  const WidgetListTile({
    Key? key,
    required this.leadWidget,
    required this.title,
    required this.subTitle,
    this.tabFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile( onTap: tabFunc,
      leading: leadWidget,
      title: WidgetText(
        text: title,
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: WidgetText(text: subTitle),
    );
  }
}
