import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  //Controladores
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha1 = TextEditingController();
  TextEditingController _controllerSenha2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _mensagemErro = "";

  //validador
  _validarCampos(){

    //Recuperar dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha1 = _controllerSenha1.text;
    String senha2 = _controllerSenha2.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){
        if(senha1.isNotEmpty){
          if(senha2.isNotEmpty && senha1 == senha2){
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
    }else{
      setState(() {
        _mensagemErro = "Preencha o nome";
      });
      return true;
    }
  }

  _cadastrarUsuario(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
        backgroundColor: Color(0xff075E54),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(color: Color(0xff075E54)),
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      'imagens/usuario.png',
                      width: 150,
                      height: 120,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all( 8),
                    child: TextFormField(
                      controller: _controllerNome,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Nome",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                      controller: _controllerSenha1,
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
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controllerSenha2,
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 20),
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: "Confirme a senha",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: ElevatedButton(
                      child: Text("Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.fromLTRB(32, 16, 32, 16)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)))),
                      onPressed: () {
                        _validarCampos();
                      },
                    ),
                  ),
                  Text(
                    _mensagemErro,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
