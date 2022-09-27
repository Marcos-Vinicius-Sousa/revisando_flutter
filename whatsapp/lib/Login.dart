import 'package:flutter/material.dart';
import 'package:whatsapp/Cadastro.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xff075E54)
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset('imagens/logo.png',
                  width: 200,
                  height: 150,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24)
                        )
                      ),
                    ),
                ),
                TextField(
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  obscureText: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24)
                      )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top:16,bottom: 10),
                  child: ElevatedButton(
                    child: Text("Entrar",
                        style: TextStyle(color: Colors.white, fontSize: 20)
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(32, 16, 32, 16)),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)
                      ))
                    ),
                    onPressed: (){

                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: Text("Não tem conta? Cadastre-se!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cadastro())
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
