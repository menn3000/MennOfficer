// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_dialog.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_button.dart';
import 'package:mennofficer/widgets/widget_form.dart';
import 'package:mennofficer/widgets/widget_progress.dart';
import 'package:mennofficer/widgets/widget_text.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  Position? position;
  bool load = true;
  Map<MarkerId, Marker> markerMap = {};
  BitmapDescriptor? bitmapDescriptor;

  String? name, detail;
  LatLng? jobLatLng;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      //create icon for Google Marker
      createIconMarker();

      // use this method to get context in the iniState which normally do not have
      findPosition(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          title: WidgetText(
            text: 'Add Job',
            textStyle: MyConstant().h2Style(),
          )),
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        //SingleChildScrollView used for making screen accept tab event
        //so we can tab and change texbox status between focus and enable
        return SingleChildScrollView(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print('you tab screen');
              FocusScope.of(context).requestFocus(FocusScopeNode());
            },
            child: Column(
              children: [
                formName(boxConstraints),
                formDetail(boxConstraints),
                mapJob(boxConstraints),
                buttonSave(),
              ],
            ),
          ),
        );
      }),
    );
  }

  WidgetButton buttonSave() {
    return WidgetButton(
      lable: 'Save job',
      pressFunc: () {
        if ((name?.isEmpty ?? true) || (detail?.isEmpty ?? true)) {
          MyDialog(context: context).normalDialog(
              title: 'Have Space', subTitle: 'Pleae fill every blank');
        } else if (jobLatLng == null) {
          MyDialog(context: context).normalDialog(
              title: 'No Position', subTitle: 'Please tab on Map');
        } else {
          processInsertJob();
        }
      },
    );
  }

  Row mapJob(BoxConstraints boxConstraints) {
    return makeCenter(
      boxConstraints,
      width: boxConstraints.maxWidth * 0.8,
      widget: Container(
        height: boxConstraints.maxHeight * 0.6,
        decoration: MyConstant().curvBox(),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: load
              ? WidgetProgress()
              : GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(position!.latitude, position!.longitude),
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  onTap: (argument) {
                    print('tab ${argument.latitude} , ${argument.longitude}');
                    jobLatLng = argument;
                    MarkerId markerId = MarkerId('id');
                    Marker marker = Marker(
                      markerId: markerId,
                      position: argument,
                      infoWindow: const InfoWindow(
                          title: 'Job Position', snippet: 'Work from here'),
                      icon: bitmapDescriptor ??
                          BitmapDescriptor.defaultMarkerWithHue(80),
                      //icon: BitmapDescriptor.defaultMarkerWithHue(80),
                    );
                    markerMap[markerId] = marker;
                    setState(() {});
                  },
                  markers: Set<Marker>.of(markerMap.values),
                ),
        ),
      ),
    );
  }

  Row formDetail(BoxConstraints boxConstraints) {
    return makeCenter(boxConstraints,
        widget: WidgetForm(
          hint: 'Detail',
          iconData: Icons.details,
          changeFunc: (p0) {
            detail = p0.trim();
          },
        ));
  }

  Row formName(BoxConstraints boxConstraints) {
    return makeCenter(boxConstraints,
        widget: WidgetForm(
          hint: 'Name job',
          iconData: Icons.work,
          changeFunc: (p0) {
            name = p0.trim();
          },
        ));
  }

  Row makeCenter(BoxConstraints boxConstraints,
      {required Widget widget, double? width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          width: width ?? boxConstraints.maxWidth * 0.6,
          child: widget,
        ),
      ],
    );
  }

  Future<void> findPosition({required BuildContext context}) async {
    await MyService().processFindPosition(context: context).then((value) {
      position = value;
      print('Position on addJob = $position');
      load = false;
      setState(() {});
    });
  }

  void createIconMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)), 'images/Home.png')
        .then(
      (value) {
        bitmapDescriptor = value;
      },
    );
  }

  Future<void> processInsertJob() async {
    //get data from SharedPreferance
    var datas = await MyService().findDatas();
    print('datas = $datas');

    DateTime dateTime = DateTime.now();
    print('dateCreate = ${dateTime.toString()}');

    JobModel jobModel = JobModel(
        job: name!,
        detail: detail!,
        idBoss: datas[0].trim(),
        lat: jobLatLng!.latitude.toString(),
        lng: jobLatLng!.longitude.toString(),
        dateCreate: dateTime.toString());

    print('jobModel = ${jobModel.toMap()}');

    String path =
        'https://www.androidthai.in.th/fluttertraining/insertJobMenn.php?isAdd=true&job=$name&detail=$detail&idBoss=${jobModel.idBoss}&lat=${jobModel.lat}&lng=${jobModel.lng}&dateCreate=${jobModel.dateCreate}';
    await Dio().get(path).then((value) {
      var statusCode = value.statusCode;
       print('Status code = $statusCode');
      Navigator.pop(context);
    });
  }
}
