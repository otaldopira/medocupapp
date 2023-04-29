import 'package:cloud_firestore/cloud_firestore.dart';

class DBfirestore {
  DBfirestore._();
  static final DBfirestore _instance = DBfirestore._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseFirestore get() => DBfirestore._instance._firestore;
}
