import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Mensagem.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class Mensagens extends StatefulWidget {
  Usuario contato;
  String emailLogado;
  Mensagens(this.contato, this.emailLogado);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  late String _emailLogado;
  late String _emailDestinatario;
  bool _subindoImagem = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController _controllerMenssagem = TextEditingController();

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if(usuarioLogado!.uid != null){
      setState(() {
        _emailLogado = widget.emailLogado;
        _emailDestinatario = widget.contato.email;
      });
    }

  }

  _enviarMenssagem() {
    String textoMensagem = _controllerMenssagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.email = _emailLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";
      mensagem.tempoMensagem = DateTime.now().toString();

      // Salvando mensagem para o remetente
      _salvarMensagem(_emailLogado, _emailDestinatario, mensagem);

      // Salvando mensagem para o destinatario
      _salvarMensagem(_emailDestinatario, _emailLogado, mensagem);
    }
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    //Salvando conversa

    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    //Limpando campo de texto após o envio
    _controllerMenssagem.clear();
  }


  _enviarFoto()async{
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if(image != null){
      UploadTask task = await upload(image.path);
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if(snapshot.state == TaskState.running){
          setState(() {
            _subindoImagem = true;
          });
        }else if(snapshot.state == TaskState.success){
          setState(() {
            _subindoImagem = false;
          });
          _recuperarURLimagem(snapshot);
        }
      });
    }
  }

  Future<UploadTask> upload(String path) async{
    File file = File(path);
    String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
    String tempoMensagem = DateTime.now().toString();
    debugPrint(tempoMensagem);
    try{
      String ref = 'mensagens/${_emailLogado}/${nomeImagem}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch(e){
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  Future _recuperarURLimagem(TaskSnapshot taskSnapshot)async{
    String url = await taskSnapshot.ref.getDownloadURL();

    Mensagem mensagem = Mensagem();
    mensagem.email = _emailLogado;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.tipo = "imagem";
    mensagem.tempoMensagem = DateTime.now().toString();

    // Salvando mensagem para o remetente
    _salvarMensagem(_emailLogado, _emailDestinatario, mensagem);

    // Salvando mensagem para o destinatario
    _salvarMensagem(_emailDestinatario, _emailLogado, mensagem);

  }


  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMenssagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _controllerMenssagem,
                autofocus: true,
                //keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: "Digite uma Menssagem",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24)),
                    prefixIcon:
                      _subindoImagem
                      ? const SizedBox(width: 3, height: 3,child: CircularProgressIndicator(strokeWidth: 1.0, color: Colors.black,))
                      :IconButton(icon: const Icon(Icons.camera_alt, color: Color(0xff075E54)), onPressed:(){ _enviarFoto();},
                    )
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              _enviarMenssagem();
            },
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
          )
        ],
      ),
    );



    var stream = StreamBuilder(
        stream: db
            .collection("mensagens")
            .doc(_emailLogado)
            .collection(_emailDestinatario)
            .orderBy("tempoMensagem")
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando Mensagens"),
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
                ),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              late QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot<Object?>?;
              if (snapshot.hasError) {
                return Expanded(child: Text("Erro ao carregar dados"));
              } else {
                return Expanded(
                  child: ListView.builder(
                      itemCount: querySnapshot?.docs.length,
                      itemBuilder: (context, indice) {
                      
                        // recuperar mensagem
                        List<DocumentSnapshot>? mensagens = querySnapshot?.docs.toList();
                        DocumentSnapshot item = mensagens![indice];
                        double larguraContainer =
                            MediaQuery.of(context).size.width * 0.8;

                        // Definindo cores e alinhamento
                        Alignment alinhamento = Alignment.centerRight;
                        Color cor = Color(0xffd2ffa5);
                        if (_emailLogado != item["email"]) {
                          cor = Colors.white;
                          alinhamento = Alignment.centerLeft;
                        }

                        return Align(
                          alignment: alinhamento,
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Container(
                              width: larguraContainer,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: cor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              child:
                              item["tipo"] == "texto"
                              ? Text(item["mensagem"], style: TextStyle(fontSize: 16),)
                              : Image.network(item["urlImagem"]),
                            ),
                          ),
                        );
                      }),
                );
              }
              break;
          }
        });

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              backgroundImage: widget.contato.urlImagem != null
                  ? NetworkImage(widget.contato.urlImagem)
                  : null,
              backgroundColor: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(widget.contato.nome),
            )
          ],
        ),
        backgroundColor: Color(0xff075E54),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              //ListView
              stream,
              caixaMenssagem
              //Caixa de Menssagem
            ],
          ),
        )),
      ),
    );
  }
}
