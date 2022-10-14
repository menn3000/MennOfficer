// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_collection_literals
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/models/user_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_dialog.dart';
import 'package:mennofficer/widgets/widget_button.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
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
  var userModels = <UserModel>[];
  UserModel? assignedUserModel;

  @override
  void initState() {
    super.initState();
    jobModel = widget.jobModel; // get parameter from the constructor

    readOfficerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: newAppBar(),
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
            titleAssignJob(),
            dropDownUser(boxConstraints),
            buttonSaveAssign(boxConstraints),
          ],
        );
      }),
    );
  }

  Row buttonSaveAssign(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: boxConstraints.maxWidth * 0.8,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: WidgetButton(
              lable: 'Save Assign',
              pressFunc: () {
                if (assignedUserModel == null) {
                  MyDialog(context: context).normalDialog(
                      title: 'No Officer selected',
                      subTitle: 'Please selected officer to assign');
                } else {
                  processEditJob();
                }
              }),
        ),
      ],
    );
  }

  Widget dropDownUser(BoxConstraints boxConstraints) {
    return userModels.isEmpty
        ? const WidgetProgress()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                decoration: MyConstant().curvBox(),
                width: boxConstraints.maxWidth * 0.8,
                child: DropdownButton(
                  focusColor: Colors
                      .white, // default color is grey and we do not want it
                  underline: const SizedBox(), // remove underline from dropdown
                  isExpanded: true, // separate arrow to the right side
                  hint: WidgetText(
                    text: 'โปรดเลือกพนักงาน',
                    textStyle: MyConstant().h3ActiveStyle(),
                  ),
                  items: userModels
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Row(
                            children: [
                              WidgetText(text: e.name),
                              WidgetText(
                                text: ' (ID = ${e.id})',
                                textStyle: MyConstant().h3ActiveStyle(),
                              )
                            ],
                          ), // onchanged parameter  (value)
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    assignedUserModel = value;
                    setState(() {});
                  },
                  value: assignedUserModel,
                ),
              ),
            ],
          );
  }

  AppBar newAppBar() {
    return AppBar(
      centerTitle: true,
      title: WidgetText(
        text: jobModel!.job,
        textStyle: MyConstant().h2Style(),
      ),
    );
  }

  Container titleAssignJob() {
    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 32),
      child: WidgetText(
        text: 'Assign job',
        textStyle: MyConstant().h2Style(size: 18),
      ),
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
          height: boxConstraints.maxHeight * 0.4,
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

  Future<void> readOfficerData() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereTypeMenn.php?isAdd=true&type=officer';
    await Dio().get(path).then((value) {
      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);
        if (userModel.idJob!.isEmpty) {
          userModels.add(userModel);
        }
      }
      setState(() {});
    });
  }

  Future<void> processEditJob() async {
    String path =
        'https://www.androidthai.in.th/fluttertraining/editJobWhereIdMenn.php?isAdd=true&id=${jobModel!.id}&idOfficer=${assignedUserModel!.id}';
    await Dio().get(path).then((value) async {
      String pathEditUser =
          'https://www.androidthai.in.th/fluttertraining/editUserWhereIDMenn.php?isAdd=true&idJob=${jobModel!.id}&id=${assignedUserModel!.id}';
      await Dio().get(pathEditUser).then((value) {
        //Wait Notification
        Navigator.pop(context);
      });
    });
  }
}
