import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  TextEditingController _controllerNome = TextEditingController();
  final ImagePicker _picker = ImagePicker();
   late final File? _imagem;
  void _setImageFile(File? value) {
    _imagem = (value == null ? null : <File?>[value]) as File?;
  }

  Future _recuperarImagem(String origemImagem)async{

     late File imagemSelecionada;
    switch(origemImagem){
      case "camera":
        imagemSelecionada = (await _picker.getImage(source: ImageSource.camera)) as File;
        break;
      case "galeria":
        imagemSelecionada = (await _picker.getImage(source: ImageSource.gallery)) as File;
        break;
    }

    setState(() {
      _setImageFile(imagemSelecionada);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
          backgroundColor: Color(0xff075E54)
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Carregando
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=886d8276-efcc-425e-83c0-0cde602ecf7c"),
                  backgroundColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        child: Text("Câmera",
                        style: TextStyle(
                          color: Color(0xff075E54)
                          ),
                        ),
                        onPressed: (){
                          _recuperarImagem("camera");
                        }),
                    TextButton(
                        child: Text("Galeria",
                        style: TextStyle(color: Color(0xff075E54)),),
                        onPressed: (){
                          _recuperarImagem("galeria");
                        }),
                  ],
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
                            borderRadius: BorderRadius.circular(24),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: ElevatedButton(
                    child: Text("Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(32, 16, 32, 16)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.green),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)))),
                    onPressed: () {

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
