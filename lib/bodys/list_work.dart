import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mennofficer/models/job_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_service.dart';
import 'package:mennofficer/widgets/widget_button.dart';
import 'package:mennofficer/widgets/widget_icon_button.dart';
import 'package:mennofficer/widgets/widget_image.dart';
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

  Position? position;
  BitmapDescriptor? officerBitMap, jobBitMap;
  Map<MarkerId, Marker> mapMarker = {};

  Map<CircleId, Circle> mapCircle = {};

  double? distance;

  String? distanceStr;
  bool work = false; // is in range

  File? file;
  var files = <File>[];

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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      newTitle(boxConstraints,
                          head: 'Job : ', value: jobModel!.job),
                      newTitle(boxConstraints,
                          head: 'Detail :', value: jobModel!.detail),
                      newTitle(
                        boxConstraints,
                        head: 'Date :',
                        value: MyService().changeDateFormat(
                                dateStr: jobModel!.dateCreate) ??
                            '',
                      ),
                      showMap(boxConstraints),
                      newTitle(
                        boxConstraints,
                        head: 'Distance',
                        value: distanceStr ?? '',
                        widget: WidgetIconButton(
                          iconData: Icons.refresh,
                          pressFunc: () {
                            findPosition();
                          },
                        ),
                      ),
                      imageTakePhoto(boxConstraints: boxConstraints),
                      gridImage(boxConstraints: boxConstraints),
                      buttonFinishJob(boxConstraints: boxConstraints),
                    ],
                  ),
                );
              })
            : Center(
                child: WidgetText(
                  text: 'No Job',
                  textStyle: MyConstant().h1Style(),
                ),
              );
  }

  Widget buttonFinishJob({required BoxConstraints boxConstraints}) {
    return work
        ? files.isNotEmpty
            ? Container(
                width: boxConstraints.maxWidth * 0.8,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: WidgetButton(
                  lable: 'Finish job',
                  pressFunc: () {
                    processUpLoadAndEditData();
                  },
                ),
              )
            : const SizedBox()
        : const SizedBox();
  }

  Widget gridImage({required BoxConstraints boxConstraints}) {
    return work
        ? files.isNotEmpty
            ? GridView.builder(
                shrinkWrap: true, // auto expand
                physics: const ScrollPhysics(),
                itemCount: files.length, // reserve memory
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ), // column you need
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: MyConstant().curvBox(),
                  width: boxConstraints.maxWidth * 0.33 - 10,
                  height: boxConstraints.maxWidth * 0.33 - 10,
                  child: InkWell(
                    onTap: () {
                      print('you tab grid index $index');
                      file = files[index];
                      setState(() {});
                    },
                    child: Image.file(
                      files[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            : const SizedBox()
        : const SizedBox();
  }

  Widget imageTakePhoto({required BoxConstraints boxConstraints}) {
    return work
        ? Column(
            children: [
              WidgetText(
                text: 'take photo',
                textStyle: MyConstant().h2Style(size: 18),
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: MyConstant().curvBox(),
                    width: boxConstraints.maxWidth * 0.8,
                    height: boxConstraints.maxWidth * 0.8,
                    child: file == null
                        ? const WidgetImage(
                            path: 'images/image.png',
                          )
                        : Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 0,
                    child: WidgetIconButton(
                      iconData: Icons.add_a_photo,
                      pressFunc: () {
                        processTakePhoto();
                      },
                    ),
                  )
                ],
              ),
            ],
          )
        : const SizedBox();
  }

  Container showMap(BoxConstraints boxConstraints) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: MyConstant().curvBox(),
      width: boxConstraints.maxWidth * 0.8,
      height: boxConstraints.maxWidth * 0.8,
      child: position == null
          ? const WidgetProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position!.latitude, position!.longitude),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              markers: Set<Marker>.of(mapMarker.values),
              circles: Set<Circle>.of(mapCircle.values),
            ),
    );
  }

  Row newTitle(BoxConstraints boxConstraints,
      {required String head, required String value, Widget? widget}) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        SizedBox(
          width: boxConstraints.maxWidth * 0.30 - 16, // -16 for padding
          child: WidgetText(
            text: head,
            textStyle: MyConstant().h2Style(size: 18),
          ),
        ),
        SizedBox(
          width: widget == null
              ? boxConstraints.maxWidth * 0.70 - 16
              : boxConstraints.maxWidth * 0.70 -
                  48, // 40 is 16 + 32 (icon width size)
          child: WidgetText(text: value),
        ),
        widget ?? const SizedBox(),
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
      findPosition();
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

  Future<void> findPosition() async {
    officerBitMap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'images/officer.png');
    jobBitMap = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)), 'images/factory.png');

    position = await MyService().processFindPosition(context: context);

    distance = MyService().calculateDistance(
      position!.latitude,
      position!.longitude,
      double.parse(jobModel!.lat),
      double.parse(jobModel!.lng),
    );

    NumberFormat numberFormat = NumberFormat('#,###.0#', 'en_US');
    distanceStr = numberFormat.format(distance);
    distanceStr = '$distanceStr m.';

    if (distance! <= MyConstant.workDistance) {
      work = true;
    } else {
      work = false;
    }

    MarkerId markerIdOfficer = const MarkerId('officer');
    Marker markerOfficer = Marker(
      markerId: markerIdOfficer,
      position: LatLng(position!.latitude, position!.longitude),
      icon: officerBitMap!,
    );

    mapMarker[markerIdOfficer] = markerOfficer;

    MarkerId markerIDJob = const MarkerId('job');
    Marker markerJob = Marker(
      markerId: markerIDJob,
      position: LatLng(
        double.parse(jobModel!.lat),
        double.parse(jobModel!.lng),
      ),
      icon: jobBitMap!,
    );

    mapMarker[markerIDJob] = markerJob;

    CircleId circleIdOfficer = const CircleId('officer');
    Circle circleOfficer = Circle(
      circleId: circleIdOfficer,
      center: LatLng(position!.latitude, position!.longitude),
      radius: MyConstant.workDistance, // unit as Meter
      strokeWidth: 1,
      strokeColor: work! ? Colors.green : MyConstant.primary.withOpacity(0.25),
      fillColor: work!
          ? Colors.green.withOpacity(0.25)
          : MyConstant.primary.withOpacity(0.25),
    );

    mapCircle[circleIdOfficer] = circleOfficer;

    setState(() {});
  }

  Future<void> processTakePhoto() async {
    var result = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxWidth: 800, maxHeight: 800);

    if (result != null) {
      file = File(result.path);
      files.add(file!);
      setState(() {});
    } else {}
  }

  Future<void> processUpLoadAndEditData() async {
    var datas = await MyService().findDatas();

    for (var element in files) {
      String nameFile = '${datas[3]}${Random().nextInt(1000000)}.jpg';
      print('filename = $nameFile');
    }
  }
}
