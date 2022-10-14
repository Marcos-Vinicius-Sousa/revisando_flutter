import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/telas/Mensagens.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _listaConversas = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _emailLogado = '';

  @override
  void initState() {
    super.initState();
    Conversa conversa = Conversa();
    conversa.nome = "Lexy";
    conversa.mensagem = "qual sera a proxima série ? ";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=1c4e370d-49a7-4368-be22-5bff83fe8e9f";
    _listaConversas.add(conversa);
    _recuperarDadosUsuario();
  }

  StreamController<QuerySnapshot<Object?>>_adicionarListenerConversas(){
    final stream = db
                  .collection("conversas")
                  .doc(_emailLogado)
                  .collection("ultima_conversa")
                  .snapshots();
    
    stream.listen((dados) {
      _controller.add(dados);
    });

    return _controller;
  }

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
      setState(() {
        _emailLogado = usuarioLogado!.email!;
        debugPrint(_emailLogado);
        _adicionarListenerConversas();
      });

  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context,snapshot){
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
          return Center(
            child: Column(
              children: [
                Text("Carregando conversas"),
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
          return Text("Erro ao carregar dados");
        }else{
          if(querySnapshot?.docs.length == 0){
            return Center(
              child: Text("Você não tem nenhuma conversa :( ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),
            );
          }

          return ListView.builder(
            itemCount: querySnapshot?.docs.length,
            itemBuilder: (context, indice) {

              // recuperar mensagem
              List<DocumentSnapshot>? conversas = querySnapshot?.docs.toList();
              DocumentSnapshot item = conversas![indice];
              Usuario usuario = Usuario();
              usuario.nome = item["nome"];
              usuario.urlImagem = item["caminhoFoto"];
              usuario.email = item["emailDestinatario"];


              return ListTile(
                onTap: (){
                  _recuperarDadosUsuario();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mensagens(usuario,_emailLogado),
                      ));
                },
                contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                leading: CircleAvatar(
                  maxRadius: 35,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(item["caminhoFoto"]),
                ),
                title: Text(
                  item["nome"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  item["tipoMensagem"] == "texto"
                  ? item["mensagem"]
                  : "imagem...",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            },
          );
        }
      }
      },
    );

  }
}
