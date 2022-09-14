import 'package:flutter/material.dart';
import 'package:revisando_flutter/screens/transferencia/lista.dart';

void main() => runApp(ByteBankApp());

class ByteBankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListaTransferencia(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple[800],
        buttonTheme: ButtonThemeData(
            buttonColor: Colors.purple,
            textTheme: ButtonTextTheme.primary,
            hoverColor: Colors.purple[900]),
      ),
    );
  }
}
