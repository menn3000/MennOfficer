import 'package:flutter/material.dart';
import 'package:mennofficer/bodys/list_finish.dart';
import 'package:mennofficer/bodys/list_work.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class MyJob extends StatefulWidget {
  const MyJob({super.key});

  @override
  State<MyJob> createState() => _MyJobState();
}

class _MyJobState extends State<MyJob> {
  var bottomNavigationBarItems = <BottomNavigationBarItem>[];
  var titles = <String>['Work', 'Finish'];
  var iconDatas = <IconData>[
    Icons.business_center_outlined,
    Icons.library_add_check_outlined,
  ];

  var bodys = <Widget>[const ListWork(), const ListFinish()];

  var indexBody = 0;

  @override
  void initState() {
    super.initState();
    setupNavigationBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: bodys[indexBody],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade200,
        currentIndex: indexBody, // set current tab here (defalut is 0 )
        selectedItemColor: Colors.pink.shade800,
        unselectedItemColor: Colors.grey.shade800,
        items: bottomNavigationBarItems,
        onTap: (value) {
          indexBody = value; // value is index of tabs
          setState(() {});
        },
      ),
    );
  }

  void setupNavigationBar() {
    for (var i = 0; i < titles.length; i++) {
      bottomNavigationBarItems.add(
        BottomNavigationBarItem(
          label: titles[i],
          icon: Icon(
            iconDatas[i],
          ),
        ),
      );
    }
  }
}
