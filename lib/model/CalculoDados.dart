
class CalculoDados{

  String _id;
  String _data;
  int _presente;
  int _estudouBiblia;
  int _pequenoGrupo;
  int _atividadeMissionaria;
  int _estudobiblico;

  CalculoDados();

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  int get estudobiblico => _estudobiblico;

  set estudobiblico(int value) {
    _estudobiblico = value;
  }

  int get atividadeMissionaria => _atividadeMissionaria;

  set atividadeMissionaria(int value) {
    _atividadeMissionaria = value;
  }

  int get pequenoGrupo => _pequenoGrupo;

  set pequenoGrupo(int value) {
    _pequenoGrupo = value;
  }

  int get estudouBiblia => _estudouBiblia;

  set estudouBiblia(int value) {
    _estudouBiblia = value;
  }

  int get presente => _presente;

  set presente(int value) {
    _presente = value;
  }
}