import 'package:flutter/material.dart';
import 'package:mennofficer/widgets/widget_sign_out.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class MainBoss extends StatelessWidget {
  const MainBoss({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WidgetText(text: 'Boss'),
      ),
      drawer: Drawer(
        child: WidgetSignOut(),
      ),
    );
  }
}
