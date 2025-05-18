import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/views/seller_screen/add_product.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Seller Dashboard".text.color(darkFontGrey).fontFamily(bold).make(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').where('seller_id', isEqualTo: currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "${data.length} Products".text.color(darkFontGrey).make(),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const AddProduct());
                        },
                        child: "+ Add Product".text.color(redColor).make(),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(
                              data[index]['p_imgs'][0],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            title: "${data[index]['p_name']}".text.make(),
                            subtitle: Row(
                              children: [
                                "\$${data[index]['p_price']}".text.color(redColor).make(),
                                10.widthBox,
                                "(${data[index]['p_quantity']} available)".text.color(darkFontGrey).make(),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                // Delete product functionality
                              },
                              icon: const Icon(Icons.delete, color: redColor),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
