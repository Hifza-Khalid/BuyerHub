import 'package:emart_app/consts/consts.dart';

Widget detailsCard(
    {required String count, required String titleText, required double width}) {
  return Container(
    width: width,
    height: 100,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        count.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
        5.heightBox,
        titleText.text.size(12).color(darkFontGrey).make(),
      ],
    ),
  );
}
