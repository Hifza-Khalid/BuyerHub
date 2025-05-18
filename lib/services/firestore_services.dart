import '../consts/firebase_consts.dart';

class FirestoreServices {
  // get users data
  static getUser(uid){
    return firestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();
  }
}