

import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';

Future<void> main() async   {

  //  WidgetsFlutterBinding.ensureInitialized();
  //  await Firebase.initializeApp();
  // FirebaseFirestore.instance
  // .collection("usuarios")
  // .doc("001")
  // .set({"nome":"Marcos"});

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff075E54),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25D366))
    ),
    debugShowCheckedModeBanner: false,
  ));
}




