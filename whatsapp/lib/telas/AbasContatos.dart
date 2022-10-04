import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  List<Usuario> listaUsuarios = [];
  late String _idUsuarioLogado;
  late String _emailUsuarioLogado;
  Usuario usuario = Usuario();
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _recuperarDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? usuarioLogado = await  auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
    _emailUsuarioLogado = usuarioLogado.email!;

  }

  Future<StreamController<QuerySnapshot<Object?>>> _listenerUsuarios() async {
    await _recuperarDadosUsuario();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("users")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return _controller;
  }

  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("users").get();
      for (var item in querySnapshot.docs) {
        var dados;
        dados = item.data();
        Map<String,dynamic> dadosUsers = item.data() as Map<String, dynamic>;

        //if(dados["email"] == _emailUsuarioLogado) continue;
        // usuario.nome = dadosUsers["nome"];
        // usuario.email = dadosUsers["email"];
        // usuario.urlImagem = dadosUsers["urlImagem"];
        // listaUsuarios.add(usuario);
        usuario.nome = dados['nome'];
        usuario.email= dados['email'];
        usuario.urlImagem = dados['urlImagem'];
        listaUsuarios.add(usuario);
      }
    return listaUsuarios;
  }

  @override
  void initState() {
    _listenerUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _controller.stream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  children: [
                    Text("Carregando contatos"),
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
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
            List<DocumentSnapshot> usuarios = querySnapshot.docs.toList();
            usuarios.removeWhere((usuario) => usuario.id == _idUsuarioLogado);
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (_, indice) {
                  DocumentSnapshot documentSnapshot = usuarios[indice];
                  Usuario usuario = Usuario.fromDocumentSnapshot(documentSnapshot);
                  return ListTile(
                    onTap: (){
                      
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 35,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                        usuario.urlImagem != null ?
                        NetworkImage(usuario.urlImagem)
                            : null
                    ),
                    title: Text(
                      usuario.nome,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              );
          }
        }else{
          return Container(
            child: Text("Vazio"),
          );
        }

      },
    );
  }
}
