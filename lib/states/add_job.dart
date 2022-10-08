import 'package:flutter/material.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_form.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class AddJob extends StatelessWidget {
  const AddJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          title: WidgetText(
            text: 'Add Job',
            textStyle: MyConstant().h2Style(),
          )),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return ListView(
          // like column
          children: [
            makeCenter(boxConstraints,
                widget: WidgetForm(
                  hint: 'Name job',
                  iconData: Icons.work,
                  changeFunc: (p0) {},
                )),
            makeCenter(boxConstraints,
                widget: WidgetForm(
                  hint: 'Detail',
                  iconData: Icons.details,
                  changeFunc: (p0) {},
                ))
          ],
        );
      }),
    );
  }

  Row makeCenter(BoxConstraints boxConstraints, {required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16),
          width: boxConstraints.maxWidth * 0.6,
          child: widget,
        ),
      ],
    );
  }
}
