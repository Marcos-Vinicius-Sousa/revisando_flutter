import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  State<AbaConversas> createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> listaConversas = [
    Conversa("Lexy", "qual sera a proxima série ? ",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=1c4e370d-49a7-4368-be22-5bff83fe8e9f"),
    Conversa("Jamilton", "Como esta indo nos estudos?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil5.jpg?alt=media&token=22b6fa76-138d-4b56-87e0-01e516b382ef"),
    Conversa("Pedro", "vai correr dia 14?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil4.jpg?alt=media&token=9f77c654-b57d-4b38-b45c-33b0ec1ed974"),
    Conversa("Marcos Vinicius", "Ola tudo bem?",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil2.jpg?alt=media&token=886d8276-efcc-425e-83c0-0cde602ecf7c"),
    Conversa("Izzys", "continue assistindo..",
        "https://firebasestorage.googleapis.com/v0/b/whatsapp-c4f12.appspot.com/o/perfil%2Fperfil3.jpg?alt=media&token=0e633e47-8b83-4a74-86f7-24bc4daa804e"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaConversas.length,
      itemBuilder: (context, indice) {
        Conversa conversa = listaConversas[indice];

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
