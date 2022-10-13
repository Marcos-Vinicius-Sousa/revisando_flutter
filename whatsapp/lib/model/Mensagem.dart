
class Mensagem {

  late String _mensagem;
  late String _urlImagem;
  late String _emailLogado;
  late String _tempoMensagem;

  //Define o tipo da mensagem, que pode ser "texto" ou "imagem"
  late String _tipo;

  Mensagem();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "mensagem": _mensagem,
      "urlImagem": _urlImagem,
       "tipo": _tipo,
      "email": _emailLogado,
      "tempoMensagem": _tempoMensagem
    };
    return map;
  }


  String get emailLogado => _emailLogado;

  set emailLogado(String value) {
    _emailLogado = value;
  }

  String get email => _emailLogado;

  set email(String value) {
    _emailLogado = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get tempoMensagem => _tempoMensagem;

  set tempoMensagem(String value) {
    _tempoMensagem = value;
  }
}