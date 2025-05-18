import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../consts/consts.dart';
import '../../widgets_common/our_button.dart';
import '../auth_screen/login_screen.dart';
import '../payment_screen/payment_method_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(Icons.shopping_cart, color: Colors.green),
            8.widthBox,
            "My Cart".text.color(darkFontGrey).fontFamily(semibold).make(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: darkFontGrey),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return _buildLoginPrompt(context);
          }

          return StreamBuilder(
            stream: _firestore
                .collection('users')
                .doc(userSnapshot.data!.uid)
                .collection('cart')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      16.heightBox,
                      "Error loading cart".text.size(18).make(),
                      8.heightBox,
                      "Please try again later".text.color(Colors.grey).make(),
                    ],
                  ),
                );
              }

              if (!snapshot.hasData) {
                return _buildLoadingIndicator();
              }

              var data = snapshot.data!.docs;

              if (data.isEmpty) {
                return _buildEmptyCart();
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(data[index], userSnapshot.data!.uid);
                      },
                    ),
                  ),
                  _buildCheckoutSection(data, userSnapshot.data!.uid),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/login.png', width: 150),
          20.heightBox,
          "Please login to view your cart".text.size(16).color(darkFontGrey).make(),
          20.heightBox,
          SizedBox(
            width: Get.width - 60,
            child: ourButton(
              color: Colors.green,
              onPress: () => Get.offAll(() => const LoginScreen()),
              textColor: whiteColor,
              title: "Login Now",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
          16.heightBox,
          "Loading your cart...".text.color(darkFontGrey).make(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_cart.png', width: 150),
          20.heightBox,
          "Your cart is empty!".text.size(18).color(darkFontGrey).make(),
          10.heightBox,
          "Browse products and add to cart".text.color(Colors.grey).make(),
          20.heightBox,
          SizedBox(
            width: Get.width - 60,
            child: ourButton(
              color: Colors.green,
              onPress: () => Get.back(),
              textColor: whiteColor,
              title: "Continue Shopping",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(DocumentSnapshot item, String userId) {
    int quantity = item['quantity'] is String ? int.parse(item['quantity']) : item['quantity'] ?? 1;
    double price = double.parse(item['price'].toString());
    double totalPrice = price * quantity;
    bool isSelected = _selectedItems.any((selectedItem) => selectedItem.id == item.id);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog(
          title: "Remove Item",
          content: const Text("Are you sure you want to remove this item?"),
          confirm: ourButton(
            color: Colors.red,
            onPress: () => Get.back(result: true),
            textColor: whiteColor,
            title: "Remove",
          ),
          cancel: ourButton(
            color: Colors.grey,
            onPress: () => Get.back(result: false),
            textColor: whiteColor,
            title: "Cancel",
          ),
        );
      },
      onDismissed: (direction) => _removeFromCart(userId, item.id),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      if (!_selectedItems.any((selectedItem) => selectedItem.id == item.id)) {
                        _selectedItems.add(item);
                      }
                    } else {
                      _selectedItems.removeWhere((selectedItem) => selectedItem.id == item.id);
                    }
                  });
                },
              ),
              10.widthBox,
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    8.heightBox,
                    Text(
                      'Rs. ${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 20, color: Colors.green),
                    onPressed: () => _updateQuantity(userId, item.id, quantity + 1),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20, color: Colors.red),
                    onPressed: () {
                      if (quantity > 1) {
                        _updateQuantity(userId, item.id, quantity - 1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(List<DocumentSnapshot> items, String userId) {
    double selectedSubtotal = _selectedItems.fold(0.0, (double sum, item) {
      double price = double.parse(item['price'].toString());
      int quantity = item['quantity'] is String ? int.parse(item['quantity']) : item['quantity'] ?? 1;
      return sum + (price * quantity);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: _selectedItems.length == items.length,
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedItems = List.from(items);
                    } else {
                      _selectedItems.clear();
                    }
                  });
                },
              ),
              "Select All".text.make(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Subtotal".text.size(16).color(darkFontGrey).make(),
              "Rs. ${selectedSubtotal.toStringAsFixed(2)}".text.size(16).color(Colors.green).fontFamily(bold).make(),
            ],
          ),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Delivery".text.size(16).color(darkFontGrey).make(),
              "Rs. 50.00".text.size(16).color(Colors.green).fontFamily(bold).make(),
            ],
          ),
          8.heightBox,
          const Divider(),
          8.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "Total".text.size(18).color(darkFontGrey).fontFamily(bold).make(),
              "Rs. ${(selectedSubtotal + 50).toStringAsFixed(2)}".text.size(18).color(Colors.green).fontFamily(bold).make(),
            ],
          ),
          16.heightBox,
          SizedBox(
            width: double.infinity,
            child: ourButton(
              color: Colors.green,
              onPress: _selectedItems.isNotEmpty
                  ? () => _checkout(_selectedItems, userId)
                  : () {}, // <-- Empty callback instead of null
              textColor: whiteColor,
              title: "Proceed to Checkout (${_selectedItems.length} items)",
            ),
          ),

        ],
      ),
    );
  }

  Future<void> _removeFromCart(String userId, String itemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .delete();
      setState(() {
        _selectedItems.removeWhere((item) => item.id == itemId);
      });
      Get.snackbar(
        "Removed",
        "Item removed from cart",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: whiteColor,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to remove item: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }

  Future<void> _updateQuantity(String userId, String itemId, int newQuantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .update({'quantity': newQuantity});
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update quantity: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }

  Future<void> _checkout(List<DocumentSnapshot> selectedItems, String userId) async {
    if (selectedItems.isEmpty) {
      Get.snackbar("Warning", "Please select items to checkout.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final cartItems = selectedItems.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        'title': data['title'],
        'price': data['price'],
        'quantity': data['quantity'],
        'image': data['image'],
      };
    }).toList();

    double selectedSubtotal = selectedItems.fold(0.0, (double sum, item) {
      double price = double.parse(item['price'].toString());
      int quantity = item['quantity'] is String ? int.parse(item['quantity']) : item['quantity'] ?? 1;
      return sum + (price * quantity);
    });

    try {
      final result = await Get.to<Map<String, dynamic>>(
            () => PaymentMethodScreen(
          totalAmount: selectedSubtotal + 50.00,
          cartItems: cartItems,
          onPaymentMethodSelected: (String method, String? account,
              List<Map<String, dynamic>> selectedItemsForPayment) async {
            if (selectedItemsForPayment.isEmpty) {
              throw Exception("No items selected for payment");
            }
            await _processOrder(
              selectedItemsForPayment,
              userId,
              selectedSubtotal + 50.00,
              method,
              account,
            );
          },
        ),
      );

      if (result != null) {
        await _processOrder(
          result['items'],
          userId,
          selectedSubtotal + 50.00,
          result['method'],
          result['account'],
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to proceed to checkout: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }

  Future<void> _processOrder(
      List<Map<String, dynamic>> items,
      String userId,
      double totalAmount,
      String paymentMethod,
      String? accountNumber,
      ) async {
    try {
      Get.dialog(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.green),
              ),
              16.heightBox,
              "Processing Payment...".text.color(darkFontGrey).make(),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final orderRef = await _firestore.collection('orders').add({
        'userId': userId,
        'items': items,
        'subtotal': totalAmount - 50.00,
        'deliveryCharge': 50.00,
        'totalAmount': totalAmount,
        'paymentMethod': paymentMethod,
        'accountNumber': accountNumber,
        'status': paymentMethod == 'cash_on_delivery' ? 'pending' : 'paid',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final batch = _firestore.batch();
      for (var item in items) {
        batch.delete(_firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(item['id']));
      }
      await batch.commit();

      Get.back();

      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: "Order Placed!".text.center.bold.make(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              16.heightBox,
              "Your order #${orderRef.id.substring(0, 8)}".text.center.make(),
              "has been placed successfully".text.center.make(),
              16.heightBox,
              "Payment Method: ${paymentMethod.replaceAll('_', ' ')}"
                  .text
                  .center
                  .bold
                  .make(),
              if (accountNumber != null)
                "Account: $accountNumber".text.center.make().pOnly(top: 8),
            ],
          ),
          actions: [
            Center(
              child: ourButton(
                color: Colors.green,
                onPress: () {
                  Get.back();
                  Get.back();
                },
                textColor: whiteColor,
                title: "Continue Shopping",
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to place order: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: whiteColor,
      );
    }
  }
}