// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mennofficer/bodys/list_officer.dart';
import 'package:mennofficer/bodys/news.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_image.dart';
import 'package:mennofficer/widgets/widget_listtile.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
import 'package:mennofficer/widgets/widget_sign_out.dart';
import 'package:mennofficer/widgets/widget_text.dart';

import '../widgets/widget_drawer_header.dart';

class MainBoss extends StatefulWidget {
  const MainBoss({super.key});

  @override
  State<MainBoss> createState() => _MainBossState();
}

class _MainBossState extends State<MainBoss> {
  var bodys = <Widget>[];
  int indexBody = 0;
  var title = <String>['List Officer', 'News'];

  var datas = <String>[];

  @override
  void initState() {
    super.initState();
    findUserLogin();
  }

  Future<void> findUserLogin() async {
    datas = await MyService().findDatas();
    bodys.add(const ListOfficer());
    bodys.add(
      News(nameLogin: datas[2]),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: title[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            const WidgetSignOut(),
            Column(
              children: [
                WidgerDrawerHeader(
                  datas: datas,
                  type: 'Boss',
                ),
                WidgetListTile(
                    leadWidget: const WidgetImage(path: 'images/list.png'),
                    title: title[0],
                    subTitle: 'List Officer in my response'),
                Divider(color: MyConstant.dark),
                WidgetListTile(
                    leadWidget: const WidgetImage(path: 'images/news.png'),
                    title: title[1],
                    subTitle: 'News for you'),
                Divider(color: MyConstant.dark),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: bodys.isEmpty ? const WidgetProgress() : bodys[indexBody]),
    );
  }
}
