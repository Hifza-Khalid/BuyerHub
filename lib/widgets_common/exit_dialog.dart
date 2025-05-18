import 'package:flutter/material.dart';
import 'package:emart_app/consts/consts.dart';

class ExitDialog extends StatelessWidget {
  final String? title;
  
  const ExitDialog({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          title!.text.fontFamily(bold).size(18).color(darkFontGrey).make(),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: "OK".text.fontFamily(bold).color(redColor).make(),
          ),
        ],
      ).box.color(lightGrey).padding(const EdgeInsets.all(12)).roundedSM.make(),
    );
  }
}
