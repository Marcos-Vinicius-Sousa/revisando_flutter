import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({Key? key}) : super(key: key);

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {

  TextEditingController _controllerNome = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

   late String _idUsuarioLogado;
   bool _upload = false;
   double total = 0;
   String? _URLrecuperada;



   Future<XFile?> getImage(String origem)async{
     final ImagePicker _picker = ImagePicker();
     switch(origem){
       case "camera":
         XFile? image = await _picker.pickImage(source: ImageSource.camera);
         return image;
       case "galeria":
         XFile? image = await _picker.pickImage(source: ImageSource.gallery);
         return image;
     }
   }

   Future<UploadTask> upload(String path) async{
     File file = File(path);

     try{
       String ref = 'perfil/img-${_idUsuarioLogado}.jpg';
       return storage.ref(ref).putFile(file);
     } on FirebaseException catch(e){
        throw Exception('Erro no upload: ${e.code}');
     }
   }


  pickAndUpload(String origem)async{
    XFile? file = await getImage(origem);
    if(file != null){
      UploadTask task = await upload(file.path);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if(snapshot.state == TaskState.running){
          setState(() {
            _upload = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        }else if(snapshot.state == TaskState.success){
          _upload = false;
          _recuperarURLimagem(snapshot);
        }
      });



    }
  }

  Future _recuperarURLimagem(TaskSnapshot taskSnapshot)async{
     String url = await taskSnapshot.ref.getDownloadURL();
     _atualizarUrlImagemFirestore(url);
     setState(() {
       _URLrecuperada = url;
     });
  }

  _atualizarUrlImagemFirestore(String url){
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "urlImagem": url
    };
    db.collection("users")
    .doc(_idUsuarioLogado)
    .update(dadosAtualizar);
  }

  _atualizarNomeFirestore(String nome){
    FirebaseFirestore db = FirebaseFirestore.instance;
    Map<String,dynamic> dadosAtualizar = {
      "nome": nome
    };
    db.collection("users")
        .doc(_idUsuarioLogado)
        .update(dadosAtualizar);
  }

  _recuperarDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
     User? usuarioLogado = await  auth.currentUser;
     _idUsuarioLogado = usuarioLogado!.uid;

     DocumentSnapshot snapshot = await db.collection("users")
    .doc(_idUsuarioLogado)
    .get();

    Map<String,dynamic>? dados = snapshot.data() as Map<String, dynamic>?;
    _controllerNome.text = dados!["nome"];

    if(dados["urlImagem"] != null){
      setState(() {
        _URLrecuperada = dados["urlImagem"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
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
                _upload
                ? Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _upload
                      ?
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${total.round()}% enviado"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color(0xff075E54),
                              ),
                            ),
                          )
                        ],
                      ) : Container()
                    ],
                  ),
                )
                : Container(),
                CircleAvatar(
                  radius: 100,
                  backgroundImage:
                  _URLrecuperada != null
                  ? NetworkImage(_URLrecuperada!)
                  : null,
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
                          pickAndUpload("camera");
                        }),
                    TextButton(
                        child: Text("Galeria",
                        style: TextStyle(color: Color(0xff075E54)),),
                        onPressed: (){
                          pickAndUpload("galeria");
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
                      _atualizarNomeFirestore(_controllerNome.text);
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
