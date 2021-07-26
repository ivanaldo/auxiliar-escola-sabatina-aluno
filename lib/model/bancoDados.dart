import 'package:escola_sabatina_alunos/model/dadosModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoDados{

  static final String nomeTabela = "dados";

  static final BancoDados _dataHelper = BancoDados._internal();
  Database _db;

  factory BancoDados(){
    return _dataHelper;
  }

  BancoDados._internal();

  get db async {

    if( _db != null ){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }

  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE $nomeTabela (nome TEXT, permissao VARCHAR, data DATETIME)";
    await db.execute(sql);

    Map<String, dynamic> dataInicial = {
      "nome"      : "N/D",
      "permissao" : "negada",
      "data"       : "10.12.2001"

    };

    db.insert(nomeTabela, dataInicial);

  }

  inicializarDB() async {

    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco_datas.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate );
    return db;

  }

  Future recuperarDados() async {

    var bancoDados = await db;
    String sql = "SELECT * FROM $nomeTabela";
    List anotacoes = await bancoDados.rawQuery( sql );
    return anotacoes;

  }

  Future<int> atualizarData(Dados dados) async {

    var bancoDados = await db;
    return await bancoDados.update(
        nomeTabela,
      dados.toMap(),
    );
  }
  Future<int> atualizarNome(Dados dados) async {

    var bancoDados = await db;
    return await bancoDados.update(
      nomeTabela,
      dados.toMap(),
    );
  }
}