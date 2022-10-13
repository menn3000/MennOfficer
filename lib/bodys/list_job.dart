// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/states/add_job.dart';
import 'package:mennofficer/states/assign_job.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_button.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
import 'package:mennofficer/widgets/widget_text.dart';
import 'package:mennofficer/widgets/widget_text_button.dart';

import '../widgets/widget_nodata.dart';

class ListJob extends StatefulWidget {
  const ListJob({super.key});

  @override
  State<ListJob> createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  bool load = true;
  bool? haveJob;

  var jobModels = <JobModel>[];

  var listWidgets = <List<Widget>>[];

  @override
  void initState() {
    super.initState();
    readJob();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: Stack(
          children: [
            load
                ? const WidgetProgress()
                : haveJob!
                    ? listMyJob()
                    : const WidgetNoData(),
            buttonAddJob(context),
          ],
        ),
      );
    });
  }

  ListView listMyJob() {
    return ListView.builder(
      itemCount: jobModels.length,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: MyConstant().curvBox(),
        child: ExpansionTile(
          leading: WidgetText(
            text: (index + 1).toString(),
            textStyle: MyConstant().h1Style(),
          ),
          subtitle: WidgetText(text: jobModels[index].status ?? ''),
          children: listWidgets[index],
          title: WidgetText(
            text: jobModels[index].job,
            textStyle: MyConstant().h2Style(size: 18),
          ),
        ),
      ),
    );
  }

  Positioned buttonAddJob(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: WidgetButton(
        lable: 'Add Job',
        pressFunc: () {
          Navigator.push(context, MaterialPageRoute(
            // route back to parent
            builder: (context) {
              return const AddJob();
            },
          )).then((value) {
            //when comeback to parent , what to do
            readJob();
          });
        },
      ),
    );
  }

  Future<void> readJob() async {
    if (jobModels.isNotEmpty) {
      jobModels.clear();
      listWidgets.clear();
    }

    var datas = await MyService().findDatas();

    String path =
        'https://www.androidthai.in.th/fluttertraining/getJobWhereIdBossMenn.php?isAdd=true&idBoss=${datas[0].trim()}';

    await Dio().get(path).then((value) {
      if (value.toString() == 'null') {
        haveJob = false;
      } else {
        haveJob = true;
        int index = 0;

        for (var element in json.decode(value.data)) {
          var widgets = <Widget>[];

          JobModel jobModel = JobModel.fromMap(element);
          jobModels.add(jobModel);

          // create list of child widget for ExpansionTile
          Widget widget = createWidget(jobModel, index: index);
          widgets.add(widget);
          listWidgets.add(widgets);

          index++;
        }
      }

      load = false;
      setState(() {});
    });
  }

  Column createWidget(JobModel jobModel, {required int index}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetText(
          text: jobModel.dateCreate,
          textStyle: MyConstant().h3ActiveStyle(color: Colors.green),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
              vertical: 32), // EdgeInsets.symmetric =>> top and bottom
          width: 250,
          child: WidgetText(
            text: jobModel.detail,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: MyConstant().curvBox(),
          width: 300,
          height: 300,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(jobModel.lat),
                  double.parse(jobModel.lng),
                ),
                zoom: 16),
            onMapCreated: (controller) {},
            // ignore: prefer_collection_literals
            markers: <Marker>[
              Marker(
                  markerId: const MarkerId('id'),
                  position: LatLng(
                    double.parse(jobModel.lat),
                    double.parse(jobModel.lng),
                  )),
            ].toSet(),
          ),
        ),
        jobModel.status == 'create'
            ? WidgetTextButton(
                label: 'Assign job to officer',
                pressFunc: () {
                  print('you tab assign $index');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AssignJob(jobModel: jobModels[index]),
                    ),
                  ).then((value) => readJob());
                })
            : const SizedBox()
      ],
    );
  }
}
