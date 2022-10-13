import 'package:flutter/material.dart';

import '../utillity/my_constant.dart';
import 'widget_text.dart';

class WidgetNoData extends StatelessWidget {
  const WidgetNoData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WidgetText(
        text: 'No job',
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
