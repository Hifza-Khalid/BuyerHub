import 'package:emart_app/consts/consts.dart';

Widget customTextField({
  String? title,
  String? hint,
  TextEditingController? controller,
  bool isPass = false,
  bool isDesc = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title != null
          ? title.text.color(redColor).fontFamily(semibold).size(16).make()
          : Container(),
      5.heightBox,
      TextFormField(
        controller: controller,
        obscureText: isPass,
        maxLines: isDesc ? 4 : 1,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontFamily: semibold,
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: redColor,
            ),
          ),
        ),
      ),
    ],
  );
}
