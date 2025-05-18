library default_connector;

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefaultConnector {
  final FirebaseFirestore _firestore;

  static final DefaultConnector _instance = DefaultConnector._(
    FirebaseFirestore.instance,
  );

  DefaultConnector._(this._firestore);

  static DefaultConnector get instance => _instance;

  // Example of using _firestore
  Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBIe2Uh5_OPITgZu-qinPxWKHXYinnPUl4',
        appId: '1:96755432259:android:1229aec3cc2b4aecd9cdf6',
        messagingSenderId: '96755432259',
        projectId: 'mad-project-38adf',
        storageBucket: 'mad-project-38adf.firebasestorage.app',
      ),
    );
    // Using _firestore
    await _firestore.collection('app_status').doc('initialization').set({
      'initialized': true,
      'timestamp': DateTime.now(),
    });
  }
}

class FirebaseDataConnect {
  static instanceFor({
    required ConnectorConfig connectorConfig,
    required String sdkType,
  }) {}
}

class ConnectorConfig {}

class CallerSDKType {
  static const String generated = 'generated';
}
