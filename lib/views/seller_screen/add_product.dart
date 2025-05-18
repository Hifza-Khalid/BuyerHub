import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/custom_textfield.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Add Product".text.color(darkFontGrey).fontFamily(bold).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            customTextField(hint: "Product Name", controller: nameController),
            10.heightBox,
            customTextField(hint: "Price", controller: priceController),
            10.heightBox,
            customTextField(hint: "Quantity", controller: quantityController),
            10.heightBox,
            customTextField(hint: "Description", controller: descController, isDesc: true),
            10.heightBox,
            SizedBox(
              width: context.screenWidth - 60,
              child: ourButton(
                color: redColor,
                onPress: () async {
                  try {
                    await FirebaseFirestore.instance.collection('products').add({
                      'p_name': nameController.text,
                      'p_price': priceController.text,
                      'p_quantity': quantityController.text,
                      'p_desc': descController.text,
                      'seller_id': currentUser!.uid,
                      'added_date': FieldValue.serverTimestamp(),
                    });
                    VxToast.show(context, msg: "Product Added");
                    Get.back();
                  } catch (e) {
                    VxToast.show(context, msg: e.toString());
                  }
                },
                textColor: whiteColor,
                title: "Add Product",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
