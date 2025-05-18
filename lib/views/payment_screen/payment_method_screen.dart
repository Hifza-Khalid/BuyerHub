import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;
  final Function(String, String?, List<Map<String, dynamic>>) onPaymentMethodSelected;

  const PaymentMethodScreen({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.onPaymentMethodSelected,
  }) : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = '';
  bool _isProcessing = false;
  String _accountNumber = '';
  List<bool> _selectedItems = [];
  bool _selectAll = true;

  @override
  void initState() {
    super.initState();
    _selectedItems = List<bool>.filled(widget.cartItems.length, true);
  }

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'jazzcash',
      'name': 'JazzCash',
      'icon': Icons.phone_android,
      'description': 'Pay via JazzCash mobile account',
      'needsAccount': true,
    },
    {
      'id': 'easypaisa',
      'name': 'EasyPaisa',
      'icon': Icons.phone_android,
      'description': 'Pay via EasyPaisa mobile account',
      'needsAccount': true,
    },
    {
      'id': 'bank_transfer',
      'name': 'Bank Transfer',
      'icon': Icons.account_balance,
      'description': 'Direct bank transfer',
      'needsAccount': true,
    },
    {
      'id': 'cash_on_delivery',
      'name': 'Cash on Delivery',
      'icon': Icons.local_shipping,
      'description': 'Pay when you receive the product',
      'needsAccount': false,
    },
    {
      'id': 'wallet',
      'name': 'App Wallet',
      'icon': Icons.account_balance_wallet,
      'description': 'Pay from your wallet balance',
      'needsAccount': false,
    },
  ];

  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? true;
      _selectedItems = List<bool>.filled(widget.cartItems.length, _selectAll);
    });
  }

  void _showAccountNumberDialog() {
    final paymentInfo = _paymentMethods.firstWhere(
          (method) => method['id'] == _selectedMethod,
      orElse: () => <String, dynamic>{},
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "${paymentInfo['name']} Payment",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Account Number",
                  hintText: "e.g. 03001234567",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _accountNumber = value;
                  });
                },
              ),
              SizedBox(height: 12),
              if (_selectedMethod == 'bank_transfer')
                TextField(
                  decoration: InputDecoration(
                    labelText: "Bank Name",
                    hintText: "e.g. HBL, MCB, etc.",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_accountNumber.isNotEmpty) {
                Get.back();
                _proceedToPayment();
              }
            },
            child: Text(
              "Confirm Payment",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    setState(() => _isProcessing = true);
    final selectedItems = <Map<String, dynamic>>[];
    for (int i = 0; i < widget.cartItems.length; i++) {
      if (_selectedItems[i]) {
        selectedItems.add(widget.cartItems[i]);
      }
    }

    widget.onPaymentMethodSelected(
      _selectedMethod,
      _accountNumber.isNotEmpty ? _accountNumber : null,
      selectedItems,
    );
  }

  Widget _buildProductImage(String imageUrl) {
    try {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        );
      } else if (imageUrl.startsWith('assets/')) {
        return Image.asset(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
        );
      }
    } catch (e) {
      print('Error loading image: $e');
    }
    return Icon(Icons.shopping_bag, size: 60);
  }

  Map<String, dynamic> _groupCartItems() {
    final groupedItems = <String, Map<String, dynamic>>{};
    final itemCounts = <String, int>{};

    for (var item in widget.cartItems) {
      final key = '${item['id']}-${item['title']}';
      if (groupedItems.containsKey(key)) {
        itemCounts[key] = (itemCounts[key] ?? 1) + 1;
      } else {
        groupedItems[key] = {...item};
        itemCounts[key] = 1;
      }
    }

    // Update quantities in grouped items
    groupedItems.forEach((key, item) {
      item['quantity'] = itemCounts[key] ?? 1;
    });

    return {
      'groupedItems': groupedItems,
      'itemCounts': itemCounts,
    };
  }

  double get _selectedTotal {
    double total = 0;
    for (int i = 0; i < widget.cartItems.length; i++) {
      if (_selectedItems[i]) {
        total += (widget.cartItems[i]['price'] * widget.cartItems[i]['quantity']);
      }
    }
    return total + 50; // Adding delivery charge
  }

  @override
  Widget build(BuildContext context) {
    final groupedData = _groupCartItems();
    final groupedItems = groupedData['groupedItems'] as Map<String, Map<String, dynamic>>;
    final itemCounts = groupedData['itemCounts'] as Map<String, int>;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Method",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Selected Items Summary
            Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            "Selected Items (${_selectedItems.where((e) => e).length}/${widget.cartItems.length})",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Checkbox(
                            value: _selectAll,
                            onChanged: _toggleSelectAll,
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Payable:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Rs. ${_selectedTotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Items Selection List
            ...groupedItems.entries.map((entry) {
              final item = entry.value;
              final count = itemCounts[entry.key] ?? 1;
              final index = widget.cartItems.indexWhere((i) =>
              i['id'] == item['id'] && i['title'] == item['title']);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CheckboxListTile(
                  value: index != -1 ? _selectedItems[index] : false,
                  onChanged: (value) {
                    setState(() {
                      if (index != -1) {
                        _selectedItems[index] = value ?? false;
                        _selectAll = _selectedItems.every((e) => e);
                      }
                    });
                  },
                  title: Row(
                    children: [
                      _buildProductImage(item['image']),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Rs. ${item['price']} x $count",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  secondary: Text(
                    "Rs. ${(item['price'] * count).toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.green,
                ),
              );
            }).toList(),

            // Payment Methods
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                "Select Payment Method",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMethod = method['id'];
                      });
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedMethod == method['id']
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedMethod == method['id']
                              ? Colors.green
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(method['icon'], size: 30, color: Colors.green),
                          SizedBox(height: 8),
                          Text(
                            method['name'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              method['description'].toString(),
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Proceed Button
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _selectedMethod.isEmpty || _selectedItems.every((e) => !e)
                    ? null
                    : () {
                  final method = _paymentMethods.firstWhere(
                        (m) => m['id'] == _selectedMethod,
                    orElse: () => <String, dynamic>{},
                  );
                  if (method['needsAccount'] == true) {
                    _showAccountNumberDialog();
                  } else {
                    _proceedToPayment();
                  }
                },
                child: _isProcessing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "PROCEED TO PAYMENT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}