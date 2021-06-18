import 'package:cloud_firestore/cloud_firestore.dart';
Future connection() async {
  FirebaseFirestore fb = FirebaseFirestore.instance;
  // CollectionReference cfb = FirebaseFirestore.instance("users");
  return fb;
}

class Connection {
  FirebaseFirestore fb = FirebaseFirestore.instance;
}
