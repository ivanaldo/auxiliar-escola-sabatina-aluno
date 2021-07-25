class Dados{

  String _nome;
  String _permissao;
  String _data;

  Dados();

  Dados.fromMap(Map map){

    this._nome      = map["nome"];
    this._permissao = map["permissao"];
    this._data      = map["data"];
  }

  Map toMap(){

    Map<String, dynamic> map = {

      "nome"      : this._nome,
      "permissao" : this._permissao,
      "data"      : this._data
    };
    return map;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get permissao => _permissao;

  set permissao(String value) {
    _permissao = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }
}
