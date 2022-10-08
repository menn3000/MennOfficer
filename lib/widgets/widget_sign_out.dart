import 'package:flutter/material.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_listtile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetSignOut extends StatelessWidget {
  const WidgetSignOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Divider(color: MyConstant.dark),
        WidgetListTile(
          leadWidget: Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.red.shade700,
          ),
          title: 'Sign out',
          subTitle: 'Sign out and move to Authen',
          tabFunc: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false));
          },
        ),
      ],
    );
  }
}
