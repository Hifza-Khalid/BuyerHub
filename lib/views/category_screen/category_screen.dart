import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart'; // Correct import for Get package
import 'package:emart_app/views/category_screen/category_details.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: "Categories".text.fontFamily(bold).white.make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            itemCount: 9,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 200,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(() => CategoryDetails(
                      title: categoriesList[
                          index])); // Navigate to CategoryDetails
                },
                child: Column(
                  children: [
                    Image.asset(
                      categoryImages[index],
                      height: 120,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    10.heightBox,
                    categoriesList[index]
                        .text
                        .color(darkFontGrey)
                        .align(TextAlign.center)
                        .make(),
                  ],
                ).box.white.rounded.clip(Clip.antiAlias).outerShadowSm.make(),
              );
            },
          ),
        ),
      ),
    );
  }
}
