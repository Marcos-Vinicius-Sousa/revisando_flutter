
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

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
  }

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "nome": nome,
      "email": email
    };
    return map;
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