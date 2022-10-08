// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mennofficer/models/user_model.dart';
import 'package:mennofficer/utillity/my_constant.dart';
import 'package:mennofficer/utillity/my_dialog.dart';
import 'package:mennofficer/widgets/widget_button.dart';
import 'package:mennofficer/widgets/widget_form.dart';
import 'package:mennofficer/widgets/widget_icon_button.dart';
import 'package:mennofficer/widgets/widget_image.dart';
import 'package:mennofficer/widgets/widget_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({super.key});

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool redEye = true;
  String? user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              return FocusScope.of(context).requestFocus(
                FocusScopeNode(),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: boxConstraints.maxHeight,
                  width: boxConstraints.maxWidth,
                  decoration: MyConstant().imageBox(),
                  child: newHead(boxConstraints),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 36,
                        top: 72,
                        right: 36,
                      ),
                      decoration: MyConstant().whiteBox(),
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight * 0.75,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            WidgetText(
                              text: 'Login :',
                              textStyle: MyConstant().h2Style(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  width: 250,
                                  child: Column(
                                    children: [
                                      WidgetForm(
                                        changeFunc: (p0) {
                                          user = p0.trim();
                                        },
                                        hint: 'User :',
                                        iconData: Icons.person_outline,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      WidgetForm(
                                        changeFunc: (p0) {
                                          password = p0.trim();
                                        },
                                        suffixWidget: WidgetIconButton(
                                          iconData: redEye
                                              ? Icons.remove_red_eye
                                              : Icons.remove_red_eye_outlined,
                                          pressFunc: () {
                                            redEye = !redEye;
                                            print('redeye = $redEye');
                                            setState(() {});
                                          },
                                        ),
                                        obsecu: redEye,
                                        hint: 'Password :',
                                        iconData: Icons.lock_outline,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: WidgetButton(
                                          lable: 'Login',
                                          pressFunc: () {
                                            print(
                                                'user = $user , password = $password');

                                            if ((user?.isEmpty ?? true) ||
                                                (password?.isEmpty ?? true)) {
                                              print('have space');
                                              MyDialog(context: context)
                                                  .normalDialog(
                                                      title: 'Have space?',
                                                      subTitle:
                                                          'Pleae fill every blank ');
                                            } else {
                                              print('no space');
                                              processLogin();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> processLogin() async {
    String urlAPI =
        'https://www.androidthai.in.th/fluttertraining/getUserWhereUserMenn.php?isAdd=true&user=$user';

    await Dio().get(urlAPI).then((value) async {
      print('value = $value');

      if (value.toString() == 'null') {
        MyDialog(context: context)
            .normalDialog(title: "Usr False", subTitle: "No $user in DB");
      } else {
        //user true
        var result = json.decode(value.data);
        print('result = $result');

        for (var element in result) {
          print('element = $element');
          UserModel model = UserModel.fromMap(element);

          if (password == model.password) {
            //Prassword true
            String type = model.type;
            print('type = $type');

            var datas = <String>[];
            datas.add(model.id);
            datas.add(model.type);
            datas.add(model.name);
            datas.add(model.user);
            datas.add(model.password);

            print('Datas = $datas');

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setStringList('data', datas).then((value) {
              switch (type) {
                case 'boss':
                  Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeBoss, (route) => false);
                  break;
                case 'officer':
                  Navigator.pushNamedAndRemoveUntil(
                      context, MyConstant.routeoOfficer, (route) => false);
                  break;
                default:
                  Navigator.restorablePushNamedAndRemoveUntil(
                      context, MyConstant.routeoOfficer, (route) => false);
                  break;
              }
            });
          } else {
            //Password false
            MyDialog(context: context).normalDialog(
                title: 'Wrong password', subTitle: 'Please try new password');
          }
        }
      }
    });
  }

  Container newHead(BoxConstraints boxConstraints) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        top: 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newImage(boxConstraints),
          const SizedBox(
            width: 16,
          ),
          WidgetText(
            text: MyConstant.appName,
            textStyle: MyConstant().h1Style(color: Colors.white),
          ),
        ],
      ),
    );
  }

  SizedBox newImage(BoxConstraints boxConstraints) {
    return SizedBox(
      width: boxConstraints.maxWidth * 0.2,
      child: const WidgetImage(),
    );
  }
}
