import 'package:flutter/material.dart';
import 'package:mennofficer/bodys/my_job.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_dialog.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_drawer_header.dart';
import 'package:mennofficer/widgets/widget_icon_button.dart';
import 'package:mennofficer/widgets/widget_listtile.dart';
import 'package:mennofficer/widgets/widget_sign_out.dart';
import 'package:qrscan/qrscan.dart';

import '../widgets/widget_text.dart';

class MainOfficer extends StatefulWidget {
  const MainOfficer({super.key});

  @override
  State<MainOfficer> createState() => _MainOfficerState();
}

class _MainOfficerState extends State<MainOfficer> {
  var datas = <String>[];
  int indexBody = 0;
  var bodys = <Widget>[];
  var titleAppBars = <String>['My Job'];

  @override
  void initState() {
    super.initState();
    findDatas();
    bodys.add(const MyJob());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          WidgetIconButton(
            iconData: Icons.qr_code,
            pressFunc: () async {
              var result = await scan();
              MyDialog(context: context)
                  .normalDialog(title: 'QR Code', subTitle: result.toString());
            },
          )
        ],
        centerTitle: true,
        title: WidgetText(text: titleAppBars[indexBody]),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            const WidgetSignOut(),
            datas.isEmpty
                ? const SizedBox()
                : Column(
                    children: [
                      WidgetDrawerHeader(datas: datas, type: 'officer'),
                      WidgetListTile(
                        leadWidget: Icon(
                          Icons.home_outlined,
                          size: 36,
                          color: Colors.green.shade700,
                        ),
                        title: 'My Job',
                        subTitle: 'Work job and Finish job',
                        tabFunc: () {
                          indexBody = 0;
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                      Divider(color: MyConstant.dark),
                    ],
                  ),
          ],
        ),
      ),
      body: bodys[indexBody],
    );
  }

  Future<void> findDatas() async {
    await MyService().findDatas().then((value) {
      datas = value;

      //for noti (need to wait for datas for data)
      aboutNoti();

      setState(() {});
    });
  }

  Future<void> aboutNoti() async {
    await MyService().processNotification(context: context, idUser: datas[0]);
  }
}
