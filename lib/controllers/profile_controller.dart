import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../consts/consts.dart';
import '../consts/firebase_consts.dart';

class ProfileController extends GetxController {
  // Firebase instances
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // Observable variables
  var profileImgPath = ''.obs;
  var profileImageLink = ''.obs;
  var isloading = false.obs;

  // Text controllers
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  // Store user data
  Rx<DocumentSnapshot?> snapshotData = Rx<DocumentSnapshot?>(null);

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      var currentUser = auth.currentUser;
      if (currentUser != null) {
        var data = await firestore
            .collection(usersCollection)
            .doc(currentUser.uid)
            .get();
        snapshotData.value = data;
      }
    } catch (e) {
      print("Error getting user data: $e");
    }
  }

  Future<void> changeImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (img == null) return;
      profileImgPath.value = img.path;
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      var currentUser = auth.currentUser;
      if (currentUser == null) throw "User not authenticated";

      var filename = basename(profileImgPath.value);
      var destination = 'images/${currentUser.uid}/$filename';
      Reference ref = storage.ref().child(destination);
      await ref.putFile(File(profileImgPath.value));
      profileImageLink.value = await ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? imgUrl,
    required String name,
    required String password,
  }) async {
    try {
      isloading(true);
      var currentUser = auth.currentUser;
      if (currentUser == null) throw "User not authenticated";

      var store = firestore.collection(usersCollection).doc(currentUser.uid);
      await store.set({
        'name': name,
        'password': password,
        if (imgUrl != null) 'imageUrl': imgUrl,
      }, SetOptions(merge: true));

      await getUserData(); // Refresh user data
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    } finally {
      isloading(false);
    }
  }

  Future<void> changeAuthPassword({
    required String email,
    required String password,
    required String newpassword,
  }) async {
    try {
      var currentUser = auth.currentUser;
      if (currentUser == null) throw "User not authenticated";

      final cred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await currentUser.reauthenticateWithCredential(cred);
      await currentUser.updatePassword(newpassword);
    } catch (e) {
      print("Error changing password: $e");
      rethrow;
    }
  }
}
