// <-- Required for core widgets
import 'package:emart_app/consts/consts.dart';

Widget bgWidget({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imgBackground),
        fit: BoxFit.fill, // <-- Corrected case
      ),
    ),
    child: child, // <-- Fixed comma and syntax
  );
}
