import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static const String stripePublishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY';
  static const String stripeSecretKey = 'sk_test_YOUR_SECRET_KEY';

  static Future<void> init() async {
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  static Future<Map<String, dynamic>> _createPaymentIntent(
      String amount,
      String currency,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount,
          'currency': currency,
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Payment intent error: ${e.toString()}');
    }
  }

  static Future<void> makePayment({
    required String amount,
    required BuildContext context,
  }) async {
    try {
      // 1. Create payment intent
      final paymentIntent = await _createPaymentIntent(amount, 'usd');
      final clientSecret = paymentIntent['client_secret'] as String;

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'emart_app',
          style: ThemeMode.dark,
        ),
      );

      // 3. Present payment sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Show success message
      VxToast.show(
        context,
        msg: "Payment Successful",
        bgColor: greenColor,
        textColor: whiteColor,
      );
    } on StripeException catch (e) {
      VxToast.show(
        context,
        msg: "Payment Failed: ${e.error.localizedMessage}",
        bgColor: redColor,
        textColor: whiteColor,
      );
    } catch (e) {
      VxToast.show(
        context,
        msg: "Error: ${e.toString()}",
        bgColor: redColor,
        textColor: whiteColor,
      );
    }
  }

  static Future<void> completePayment(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'payment_status': 'paid',
        'paid_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }
}
