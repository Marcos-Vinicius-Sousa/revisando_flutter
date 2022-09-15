
import 'package:flutter/material.dart';
import 'package:whatsapp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {

  // WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  FirebaseFirestore.instance
  .collection("usuarios")
  .doc("001")
  .set({"nome":"Marcos"});

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}




