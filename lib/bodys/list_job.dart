import 'package:flutter/material.dart';
import 'package:mennofficer/states/add_job.dart';
import 'package:mennofficer/widgets/widget_button.dart';

class ListJob extends StatelessWidget {
  const ListJob({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints boxConstraints) {
      return Stack(
        children: [
          Positioned(
            bottom: 16,
            right: 16,
            child: WidgetButton(
              lable: 'Add Job',
              pressFunc: () {
                Navigator.push(context, MaterialPageRoute( // route back to parent
                  builder: (context) {
                    return const AddJob();
                  },
                )).then((value) {
                  //when comeback to parent , what to do
                });
              },
            ),
          ),
        ],
      );
    });
  }
}
