// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_collection_literals
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class AssignJob extends StatefulWidget {
  final JobModel jobModel;

  const AssignJob({
    Key? key,
    required this.jobModel,
  }) : super(key: key);

  @override
  State<AssignJob> createState() => _AssignJobState();
}

class _AssignJobState extends State<AssignJob> {
  JobModel? jobModel;

  @override
  void initState() {
    super.initState();
    jobModel = widget.jobModel; // get parameter from the constructor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: WidgetText(
          text: jobModel!.job,
          textStyle: MyConstant().h2Style(),
        ),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            newHead(
                boxConstraints: boxConstraints,
                head: 'Date create :',
                value: jobModel!.dateCreate),
            newHead(
                boxConstraints: boxConstraints,
                head: 'Detail :',
                value: jobModel!.detail),
            newMap(boxConstraints),
            Container(
              margin: EdgeInsets.only(left: 16, bottom: 32),
              child: WidgetText(
                text: 'Assign job',
                textStyle: MyConstant().h2Style(size: 18),
              ),
            ),
          ],
        );
      }),
    );
  }

  Row newMap(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: MyConstant().curvBox(),
          margin: const EdgeInsets.symmetric(vertical: 32),
          width: boxConstraints.maxWidth * 0.8,
          height: boxConstraints.maxWidth * 0.6,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                double.parse(jobModel!.lat),
                double.parse(jobModel!.lng),
              ),
              zoom: 16,
            ),
            onMapCreated: (controller) {},
            markers: <Marker>[
              Marker(
                  markerId: const MarkerId('id'),
                  position: LatLng(
                    double.parse(jobModel!.lat),
                    double.parse(jobModel!.lng),
                  )),
            ].toSet(),
          ),
        ),
      ],
    );
  }

  Row newHead(
      {required BoxConstraints boxConstraints,
      required String head,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          width: boxConstraints.maxWidth * 0.25,
          child: WidgetText(
            text: head,
            textStyle: MyConstant().h2Style(size: 16),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: boxConstraints.maxWidth * 0.75,
          child: WidgetText(
            text: value,
            textStyle: MyConstant().h2Style(size: 16),
          ),
        ),
      ],
    );
  }
}
