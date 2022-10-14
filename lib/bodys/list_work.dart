import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class ListWork extends StatefulWidget {
  const ListWork({super.key});

  @override
  State<ListWork> createState() => _ListWorkState();
}

class _ListWorkState extends State<ListWork> {
  var datas = <String>[];

  bool load = true;
  bool? haveJob;
  JobModel? jobModel;

  @override
  void initState() {
    super.initState();
    findDatas();
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const WidgetProgress()
        : haveJob!
            ? LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    newTitle(boxConstraints,
                        head: 'Job : ', value: jobModel!.job),
                    newTitle(boxConstraints,
                        head: 'Detail :', value: jobModel!.detail),
                    newTitle(
                      boxConstraints,
                      head: 'Date :',
                      value: MyService()
                          .changeDateFormat(dateStr: jobModel!.dateCreate) ?? '',
                    ),
                  ],
                );
              })
            : Center(
                child: WidgetText(
                  text: 'No Job',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  Row newTitle(BoxConstraints boxConstraints,
      {required String head, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: boxConstraints.maxWidth * 0.25 - 16, // -16 for padding
          child: WidgetText(
            text: head,
            textStyle: MyConstant().h2Style(size: 18),
          ),
        ),
        SizedBox(
          width: boxConstraints.maxWidth * 0.75 - 16, // -16 for padding
          child: WidgetText(text: value),
        ),
      ],
    );
  }

  Future<void> findDatas() async {
    await MyService().findDatas().then((value) {
      datas = value;
      readMyJob();
    });
    setState(() {});
  }

  Future<void> readMyJob() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/getJobWhereIdOfficerMenn.php?isAdd=true&idOfficer=${datas[0]}';
    await Dio().get(path).then((value) {
      load = false;

      if (value.toString() == 'null') {
        haveJob = false;
      } else {
        haveJob = true;
        for (var element in json.decode(value.data)) {
          jobModel = JobModel.fromMap(element);
        }
      }

      setState(() {});
    });
  }
}
