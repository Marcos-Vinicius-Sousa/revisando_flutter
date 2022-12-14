
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

  late String _idUsuario;
  late String _nome;
  late String _email;
  late String _senha;
  late String _urlImagem;


  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.nome = documentSnapshot["nome"];
    this.email = documentSnapshot["email"];
    this.urlImagem = documentSnapshot["urlImagem"];
    this.idUsuario = documentSnapshot["idUsuario"];
  }
  Usuario.fromDocumentSnapshot2(DocumentSnapshot documentSnapshot) {
    this.email = documentSnapshot["emailRemetente"];
    this.urlImagem = documentSnapshot["caminhoFoto"];
    this.nome = documentSnapshot["nome"];

  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "nome": nome,
      "email": email,
      "idUsuario": idUsuario,
      "urlImagem": urlImagem
    };
    return map;
  }


  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}