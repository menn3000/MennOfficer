// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../utillity/my_constant.dart';
import 'widget_image.dart';
import 'widget_text.dart';

class WidgetDrawerHeader extends StatelessWidget {
  final List<String> datas;
  final String type;

  const WidgetDrawerHeader({
    Key? key,
    required this.datas,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      currentAccountPicture: const WidgetImage(),
      accountName: datas.isEmpty
          ? const SizedBox()
          : WidgetText(
              text: datas[2],
              textStyle: MyConstant().h2Style(),
            ),
      accountEmail: WidgetText(text: type),
      decoration: MyConstant().gradientBox(),
    );
  }
}
