import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/Home.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);


  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  /* Adicionar dados */
  //CollectionReference users = FirebaseFirestore.instance.collection('usuarios');

  //Controladores
  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSenha1 = TextEditingController();
  TextEditingController controllerSenha2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _mensagemErro = "";

  //validador
  _validarCampos(){

    //Recuperar dados dos campos
    String nome = controllerNome.text;
    String email = controllerEmail.text;
    String senha1 = controllerSenha1.text;
    String senha2 = controllerSenha2.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha1.isNotEmpty && senha1.length > 6){
          if(senha2.isNotEmpty && senha1 == senha2){

            Usuario usuario = Usuario();
            usuario.nome = nome;
            usuario.email = email;
            usuario.senha = senha1;
            _cadastrarUsuario(usuario);
            setState(() {
              _mensagemErro = "Sucesso";
            });
            return false;
          }else{
            setState(() {
              _mensagemErro = "Confirme a senha corretamente";
            });
            return true;
          }
        }else{
          setState(() {
            _mensagemErro = "Preencha a senha com mais de 6 caracteres";
          });
          return true;
        }
      }else{
        setState(() {
          _mensagemErro = "Preencha o email corretamente";
        });
        return true;
      }
    }else{
      setState(() {
        _mensagemErro = "Preencha o nome";
      });
      return true;
    }
  }

  // Future<void> addUser(Usuario usuario) {
  //   return users.add({'nome': usuario.nome, 'email': usuario.email}).then((value) {
  //     debugPrint("Usuário adicionado");
  //
  //     // ignore: invalid_return_type_for_catch_error
  //   }).catchError((error) => debugPrint("Falha ao adicionar usuário: $error"));
  // }

  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser) {

      //Salvando dados do usuario
       FirebaseFirestore db = FirebaseFirestore.instance;
       db.collection("users")
      .doc(firebaseUser.user?.uid)
       .set(usuario.toMap());
      //addUser(usuario);


       Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context)=> const Home(),
           )
       );
    }).catchError((error){
      setState(() {
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos e tente novamente";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro"),
        centerTitle: true,
        backgroundColor: const Color(0xff075E54),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff075E54)),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      'imagens/usuario.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all( 8),
                    child: TextFormField(
                      controller: controllerNome,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Nome",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "E-mail",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerSenha1,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 20),
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerSenha2,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 20),
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Confirme a senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(32, 16, 32, 16)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)))),
                      onPressed: () {
                        _validarCampos();
                      },
                      child: const Text("Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                  Text(
                    _mensagemErro,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
