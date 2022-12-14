

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/routes/RouteGenerator.dart';

Future<void> main() async   {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
      primaryColor: Color(0xff075E54),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff25D366))
    ),
    //initialRoute: "/login",
    //onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}




