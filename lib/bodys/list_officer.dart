import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/models/user_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class ListOfficer extends StatefulWidget {
  const ListOfficer({super.key});

  @override
  State<ListOfficer> createState() => _ListOfficerState();
}

class _ListOfficerState extends State<ListOfficer> {
  bool load = true;
  var userModels = <UserModel>[];
  var jobModels = <JobModel?>[];

  @override
  void initState() {
    super.initState();
    readMyOfficer();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const WidgetProgress()
        : ListView.builder(
            //listview is like column , builder will gen widget and insert
            itemCount: userModels.length,
            itemBuilder: (context, index) {
              return Card(
                color: index % 2 == 1 ? Colors.white : Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetText(
                        text: userModels[index].name,
                        textStyle: MyConstant().h2Style(size: 18),
                      ),
                      Row(
                        children: [
                          WidgetText(
                            text: 'Job :',
                            textStyle: MyConstant().h3ActiveStyle(),
                          ),
                          WidgetText(text: jobModels[index]?.job ?? 'No job assigned'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Future<void> readMyOfficer() async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereOfficerMenn.php?isAdd=true';
    await Dio().get(urlAPI).then((value) async {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        userModels.add(userModel);

        if (userModel.idJob!.isEmpty) {
          jobModels.add(null);
        } else {
          jobModels
              .add(await MyService().findJobWhereid(idJob: userModel.idJob!));
        }
      }

      load = false;
      setState(() {});
    });
  }
}
