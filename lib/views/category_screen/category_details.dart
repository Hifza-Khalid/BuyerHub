import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/bg_widget.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import 'items.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;

  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();

    // Create a list of sample products with unique names
    final List<Map<String, dynamic>> sampleProducts = [
      {
        'id': 'prod1',
        'title': 'Laptop 4GB/64GB',
        'price': 600,
        'image': imgP1,
        'rating': 4.0,
        'description': 'High performance laptop with 4GB RAM and 64GB storage',
        'quantity': 10,
      },
      {
        'id': 'prod2',
        'title': 'Smartphone 6.5" HD',
        'price': 300,
        'image': imgP2,
        'rating': 4.5,
        'description': '6.5 inch HD display smartphone with dual camera',
        'quantity': 15,
      },
      {
        'id': 'prod3',
        'title': 'Wireless Headphones',
        'price': 150,
        'image': imgP3,
        'rating': 4.2,
        'description': 'Noise cancelling wireless headphones with 20hrs battery',
        'quantity': 20,
      },
      {
        'id': 'prod4',
        'title': 'Smart Watch',
        'price': 200,
        'image': imgP4,
        'rating': 3.8,
        'description': 'Fitness tracker with heart rate monitor',
        'quantity': 12,
      },
      {
        'id': 'prod5',
        'title': 'Bluetooth Speaker',
        'price': 120,
        'image': imgP5,
        'rating': 4.7,
        'description': 'Portable Bluetooth speaker with 10W output',
        'quantity': 8,
      },
      {
        'id': 'prod6',
        'title': 'Power Bank 10000mAh',
        'price': 80,
        'image': imgP6,
        'rating': 4.1,
        'description': 'Fast charging power bank with dual USB ports',
        'quantity': 25,
      },
    ];

    return bgWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title!, style: const TextStyle(color: Colors.white, fontFamily: bold)),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    controller.subcat.length,
                        (index) => "${controller.subcat[index]}"
                        .text
                        .size(20)
                        .fontFamily(semibold)
                        .color(darkFontGrey)
                        .makeCentered()
                        .box
                        .white
                        .rounded
                        .size(120, 60)
                        .margin(const EdgeInsets.symmetric(horizontal: 4))
                        .make(),
                  ),
                ),
              ),
              20.heightBox,
              Expanded(
                child: Container(
                  color: lightGrey,
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sampleProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final product = sampleProducts[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            product['image'],
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          product['title']
                              .toString()
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          10.heightBox,
                          "\$${product['price']}"
                              .text
                              .fontFamily(bold)
                              .color(redColor)
                              .size(16)
                              .make(),
                        ],
                      )
                          .box
                          .white
                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                          .roundedSM
                          .outerShadowSm
                          .padding(const EdgeInsets.all(12))
                          .make()
                          .onTap(() {
                        Get.to(() => ItemDetails(
                          title: product['title'],
                          data: product,
                        ));
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}