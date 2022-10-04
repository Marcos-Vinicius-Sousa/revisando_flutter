import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Cadastro.dart';
import 'package:whatsapp/model/Usuario.dart';

import 'Home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //Controladores
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  //validador
  _validarCampos(){

    //Recuperar dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;



      if(email.isNotEmpty && email.contains("@")){

        if(senha.isNotEmpty ){
          setState(() {
            _mensagemErro="";
          });

          Usuario usuario = Usuario();
          usuario.email = email;
          usuario.senha = senha;
          _logarUsuario(usuario);

          return false;
        }else{
          setState(() {
            _mensagemErro = "Preencha a senha";
          });
          return true;
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha o email corretamente";
        });
        return true;
      }
    }

    _logarUsuario(Usuario usuario){

      FirebaseAuth auth = FirebaseAuth.instance;
      auth.signInWithEmailAndPassword(
          email: usuario.email,
          password: usuario.senha
      ).then((firebaseUser) => {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=> Home(),)
      )
      }).catchError((error){
        setState(() {
        _mensagemErro = "Erro ao autenticar usuário, verifique email,senha e tente novamente";
          });
      });
    }

    Future _verificarUsuarioLogado() async {

      FirebaseAuth auth = FirebaseAuth.instance;
       User? usuarioLogado = await auth.currentUser;
       //auth.signOut();

      if(usuarioLogado != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context)=> const  Home(),
            )
        );
      }
    }

    @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();

  }

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
                    child: TextFormField(
                      controller: _controllerEmail,
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
                TextFormField(
                  controller: _controllerSenha,
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
                      _validarCampos();
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
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(_mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                      ),
                    ),
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
