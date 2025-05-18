import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:emart_app/consts/consts.dart';

class ProductController extends GetxController {
  // Regular list for subcategories (non-reactive)
  var subcat = [];

  // Observable list for products
  var products = <Map<String, dynamic>>[].obs;
  final productList = <Map<String, dynamic>>[].obs;

  // Loading state
  var isLoading = false.obs;

  // Selected category
  var selectedCategory = ''.obs;

  // Fetch subcategories
  Future<void> getSubCategories(String? title) async {
    subcat.clear();
    selectedCategory.value = title ?? '';


    try {
      isLoading(true);
      var data = await firestore
          .collection('products')
          .where('p_category', isEqualTo: title)
          .get();

      if (data.docs.isNotEmpty) {
        for (var element in data.docs) {
          if (element['p_subcategory'] != null) {
            subcat.add(element['p_subcategory']);
          }
        }
      }
      subcat = subcat.toSet().toList(); // Remove duplicates
    } catch (e) {
      VxToast.show(Get.context!, msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fetch all products for current category
  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      var data = await firestore
          .collection('products')
          .where('p_category', isEqualTo: selectedCategory.value)
          .get();

      // Properly update observable list
      products.assignAll(data.docs.map((doc) {
        var data = doc.data();
        return {
          'id': doc.id,
          'p_name': data['p_name'],
          'p_price': data['p_price'],
          'p_imgs': data['p_imgs'] ?? [imgP1],
          'p_desc': data['p_desc'] ?? 'No description',
          'p_quantity': data['p_quantity'] ?? 0,
        };
      }).toList());
    } catch (e) {
      VxToast.show(Get.context!, msg: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fetch products by subcategory
  Future<void> fetchProductsBySubcategory(String subcategory) async {
    try {
      isLoading(true);
      var data = await firestore
          .collection('products')
          .where('p_category', isEqualTo: selectedCategory.value)
          .where('p_subcategory', isEqualTo: subcategory)
          .get();

      // Properly update observable list
      products.assignAll(data.docs.map((doc) {
        var data = doc.data();
        return {
          'id': doc.id,
          'p_name': data['p_name'],
          'p_price': data['p_price'],
          'p_imgs': data['p_imgs'] ?? [imgP1],
          'p_desc': data['p_desc'] ?? 'No description',
          'p_quantity': data['p_quantity'] ?? 0,
        };
      }).toList());
    } catch (e) {
      VxToast.show(Get.context!, msg: e.toString());
    } finally {
      isLoading(false);
    }
  }
}