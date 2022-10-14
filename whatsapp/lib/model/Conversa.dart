import 'package:cloud_firestore/cloud_firestore.dart';


class Conversa {

  late String _emailRemetente;
  late String _emailDestinatario;
  late String _tipoMensagem;
  late String _caminhoFoto;
  late String _nome;
  late String _mensagem;


  String get emailRemetente => _emailRemetente;

  set emailRemetente(String value) {
    _emailRemetente = value;
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "emailRemetente": emailRemetente,
      "emailDestinatario": emailDestinatario,
      "tipoMensagem": tipoMensagem,
      "mensagem": mensagem,
      "caminhoFoto": caminhoFoto,
      "nome": nome,
    };
    return map;
  }

  Conversa();

  salvar()async{
    FirebaseFirestore db = FirebaseFirestore.instance;
            db
            .collection("conversas")
            .doc(this.emailRemetente)
            .collection("ultima_conversa")
            .doc(this.emailDestinatario)
            .set(this.toMap());
    
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }



  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  String get emailDestinatario => _emailDestinatario;

  set emailDestinatario(String value) {
    _emailDestinatario = value;
  }

  String get tipoMensagem => _tipoMensagem;

  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }
}