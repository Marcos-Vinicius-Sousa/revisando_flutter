import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _listaConversas = [];

  @override
  void initState() {
    super.initState();
    Conversa conversa = Conversa();
    conversa.nome = "Lexy";
    conversa.mensagem = "qual sera a proxima série ? ";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=1c4e370d-49a7-4368-be22-5bff83fe8e9f";
    _listaConversas.add(conversa);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _listaConversas.length,
      itemBuilder: (context, indice) {
        Conversa conversa = _listaConversas[indice];

        return ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          leading: CircleAvatar(
            maxRadius: 35,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(conversa.caminhoFoto),
          ),
          title: Text(
            conversa.nome,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            conversa.mensagem,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      },
    );
  }
}
