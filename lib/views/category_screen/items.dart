import 'package:flutter/material.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class ItemDetails extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? data;

  const ItemDetails({Key? key, required this.title, this.data}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int quantity = 1;
  Color selectedColor = Colors.red;
  List<Color> colorOptions = [Colors.red, Colors.green, Colors.blue];
  bool isAddingToCart = false;

  // Get current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  // Calculate total price
  int get price => widget.data?['price'] ?? 30000;
  int get totalPrice => price * quantity;

  // Exit Dialog Widget
  Widget exitDialog(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          "Login Required".text.size(18).fontFamily(bold).make(),
          const Divider(),
          10.heightBox,
          "You need to login before adding items to cart".text.make(),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ourButton(
                color: redColor,
                textColor: whiteColor,
                title: "Cancel",
                onPress: () => Navigator.pop(context),
              ),
              ourButton(
                color: redColor,
                textColor: whiteColor,
                title: "Login",
                onPress: () {
                  // Add your login navigation here
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ).box.padding(const EdgeInsets.all(12)).make(),
    );
  }

  Future<void> addToCart() async {
    if (currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => exitDialog(context),
      );
      return;
    }

    setState(() => isAddingToCart = true);

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cart');

      // Check if item already exists in cart
      final querySnapshot = await cartRef
          .where('product_id', isEqualTo: widget.data?['id'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update quantity if item exists
        final docId = querySnapshot.docs.first.id;
        final existingQuantity = querySnapshot.docs.first['quantity'] as int? ?? 0;
        final newQuantity = existingQuantity + quantity;
        final newTotalPrice = price * newQuantity;

        await cartRef.doc(docId).update({
          'quantity': newQuantity,
          'total_price': newTotalPrice,
        });
      } else {
        // Add new item to cart
        await cartRef.add({
          'product_id': widget.data?['id'],
          'title': widget.title,
          'price': price,
          'quantity': quantity,
          'total_price': totalPrice,
          'color': selectedColor.value.toRadixString(16),
          'image': widget.data?['image'] ?? imgFc5,
          'added_on': DateTime.now(),
        });
      }

      VxToast.show(context, msg: "Added to cart successfully");
    } catch (e) {
      VxToast.show(context, msg: "Error adding to cart: $e");
      print("Error adding to cart: $e");
    } finally {
      setState(() => isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share, color: darkFontGrey),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_outline, color: darkFontGrey),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Images
                  VxSwiper.builder(
                    itemCount: widget.data?['images']?.length ?? 1,
                    aspectRatio: 16/9,
                    autoPlay: true,
                    height: 250,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.data?['images']?[index] ?? imgFc5,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  20.heightBox,

                  // Product Details
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Rating
                        Row(
                          children: [
                            Expanded(
                              child: widget.title.text.size(18).fontFamily(bold).make(),
                            ),
                            VxRating(
                              onRatingUpdate: (value) {},
                              normalColor: textfieldGrey,
                              selectionColor: golden,
                              count: 5,
                              size: 20,
                              stepInt: true,
                              value: widget.data?['rating']?.toDouble() ?? 4.0,
                            ),
                          ],
                        ),
                        10.heightBox,

                        // Price
                        Row(
                          children: [
                            "\$${price.toStringAsFixed(2)}"
                                .text.color(redColor).size(18).fontFamily(bold).make(),
                            10.widthBox,
                            "\$${(price * 1.2).toStringAsFixed(2)}"
                                .text.color(textfieldGrey).size(14).lineThrough.make(),
                            10.widthBox,
                            "20% OFF".text.color(Colors.green).size(14).make(),
                          ],
                        ),
                        20.heightBox,

                        // Color Selection
                        "Color Options".text.fontFamily(semibold).make(),
                        10.heightBox,
                        Row(
                          children: colorOptions.map((color) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                VxBox()
                                    .size(40, 40)
                                    .roundedFull
                                    .color(color)
                                    .margin(const EdgeInsets.only(right: 8))
                                    .make()
                                    .onTap(() {
                                  setState(() => selectedColor = color);
                                }),
                                if (selectedColor == color)
                                  const Icon(Icons.check, color: Colors.white),
                              ],
                            );
                          }).toList(),
                        ),
                        20.heightBox,

                        // Quantity
                        "Quantity".text.fontFamily(semibold).make(),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                            ),
                            quantity.text.size(18).fontFamily(bold).make(),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() => quantity++);
                              },
                            ),
                            const Spacer(),
                            "Available: ${widget.data?['quantity'] ?? 99}"
                                .text.color(textfieldGrey).make(),
                          ],
                        ),
                        20.heightBox,

                        // Description
                        "Description".text.fontFamily(bold).size(16).make(),
                        5.heightBox,
                        (widget.data?['description'] ?? "No description available").toString().text.color(darkFontGrey).make(),
                        20.heightBox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar with Add to Cart Button
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ourButton(
                color: redColor,
                textColor: whiteColor,
                title: isAddingToCart ? "Adding..." : "Add to Cart (\$$totalPrice)",
                onPress: addToCart,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
