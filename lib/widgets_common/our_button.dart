import 'package:emart_app/consts/consts.dart';

Widget ourButton({
  required VoidCallback onPress,
  required Color color,
  required Color textColor,
  required String title,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color, // Updated from 'primary'
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress, // Corrected to actually call the function
    child: title.text.color(textColor).fontFamily(bold).make(),
  );
}
