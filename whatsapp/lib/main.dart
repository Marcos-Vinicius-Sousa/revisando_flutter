
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async   {

   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  FirebaseFirestore.instance
  .collection("usuarios")
  .doc("001")
  .set({"nome":"Marcos"});

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}




