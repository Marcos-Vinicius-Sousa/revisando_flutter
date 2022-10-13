import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/telas/Mensagens.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  State<AbaContatos> createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {
  late String _idUsuarioLogado;
  late String _emailLogado;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    setState(() {
      _idUsuarioLogado = usuarioLogado!.uid;
      _emailLogado = usuarioLogado.email!;
    });
  }

  Future<StreamController<QuerySnapshot<Object?>>> _listenerUsuarios() async {
    await _recuperarDadosUsuario();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db.collection("users").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return _controller;
  }

  @override
  void initState() {
    super.initState();
    _listenerUsuarios();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: const [
                  Text("Carregando contatos"),
                  Padding(
                    padding: EdgeInsets.all(8),
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
                Usuario usuario =
                    Usuario.fromDocumentSnapshot(documentSnapshot);
                return ListTile(
                  onTap: () {
                    _recuperarDadosUsuario();
                    debugPrint(usuario.idUsuario);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mensagens(usuario,_emailLogado),
                        ));
                  },
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                      maxRadius: 35,
                      backgroundColor: Colors.grey,
                      backgroundImage: usuario.urlImagem != null
                          ? NetworkImage(usuario.urlImagem)
                          : null),
                  title: Text(
                    usuario.nome,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
