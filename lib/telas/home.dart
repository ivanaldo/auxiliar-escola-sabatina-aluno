import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/contatos/anciao.dart';
import 'package:escola_sabatina_alunos/contatos/membros.dart';
import 'package:escola_sabatina_alunos/contatos/pastor.dart';
import 'package:escola_sabatina_alunos/contatos/professor.dart';
import 'package:escola_sabatina_alunos/model/CalculoDados.dart';
import 'package:escola_sabatina_alunos/model/bancoDados.dart';
import 'package:escola_sabatina_alunos/model/dadosModel.dart';
import 'package:escola_sabatina_alunos/telas/alunosClasse.dart';
import 'package:escola_sabatina_alunos/telas/fechaApp.dart';
import 'package:escola_sabatina_alunos/telas/loginAluno.dart';
import 'package:escola_sabatina_alunos/telas/reclamacaoSugestao.dart';
import 'package:escola_sabatina_alunos/telasClasse/classe.dart';
import 'package:escola_sabatina_alunos/videos/resumoLicoes.dart';
import 'package:escola_sabatina_alunos/videos/videosPrincipal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  bool _validar;
  String _nome;
  String _dataBD;
  Home(this._validar, this._nome, this._dataBD);

  @override
  _HomeState createState() => _HomeState();

}
int _g = 0;
bool _progresBarLinear;
bool tempo;
String data;
FToast fToast;
String dia;

class _HomeState extends State<Home> {

  var _db = BancoDados();

  _atualizarData(Dados dadosAtual) async {

    _db.atualizarNome(dadosAtual);
    _db.atualizarData( dadosAtual );

  }

  CalculoDados calculo = CalculoDados();
  bool _isButtonDisabled = false;
  bool presenca;
  bool estudouBiblia;
  bool pequenoGrupo;
  bool atividadeMissionaria;
  bool estudobiblico;


  _liberaBotoes() async {
    DateTime date = DateTime.now();
    date = DateTime(date.year, date.month, date.day-1);
    data = DateFormat("dd.MM.yyyy").format(date);
    dia = DateFormat("EEEE").format(date);

    if (dia == "Saturday" && data != widget._dataBD && widget._validar != true) {

      setState(() {
        presenca = false;
        estudouBiblia = false;
        pequenoGrupo = false;
        atividadeMissionaria = false;
        estudobiblico = false;
      });

    } else {
      setState(() {
        presenca = true;
        estudouBiblia = true;
        pequenoGrupo = true;
        atividadeMissionaria = true;
        estudobiblico = true;
      });
    }

  }

  List<String> itensMenu = [
    "Contato Pastor", "Contato Ancião", "Contato Professor", "Contato Membros", "Preseça dos alunos", "Situação da classe"
  ];

  _escolhaMenuItem(String itemEscolhido) {

    switch (itemEscolhido) {
      case "Contato Pastor":
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Pastor()),
        );
        break;
      case "Contato Ancião":
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Anciao()),
        );
        break;
      case "Contato Professor":
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Professor()),
        );
        break;
      case "Contato Membros":
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => Membros()),
        );
        break;
      case "Preseça dos alunos":
        Navigator.push(context, MaterialPageRoute(builder: (context) => AlunosClasse() )
        );
        break;
      case "Situação da classe":
        if(widget._validar == false && presenca == true && estudouBiblia == true && pequenoGrupo == true && atividadeMissionaria == true && estudobiblico == true){

          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Classe(widget._nome, widget._dataBD)),
          );
        }else if(widget._validar == true){
          Navigator.pop(context);
        }else{
          Widget toast = Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colors.black45,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12.0,
                ),
                Text("Primeiro responda as perguntas!",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
              ],
            ),
          );
          fToast.showToast(
            child: toast,
            gravity: ToastGravity.TOP,
            toastDuration: Duration(seconds: 2),
          );
        }
        break;
    }
  }
  _salvarDadosAluno(){

    var usuario = FirebaseAuth.instance.currentUser;
    String idClasse = usuario.uid;

    String presenca;
    int valor = calculo.presente;
    if(valor == 1){
      presenca = "P";
    }else{
      presenca = "F";
    }

    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance
        .collection("alunos")
        .doc(widget._nome)
        .set(
        {
          "nome"        : widget._nome,
          "presenca"    : presenca,
          "data"        : data,
          "idClasse"    : idClasse

        }).then((value){

    });

  }

  _salvarDados(){
    DateTime date = DateTime.now();
    String data = DateFormat("dd/MM/yyyy").format(date);
    calculo.data = data;
    _progresBarLinear = true;

    FirebaseAuth auth = FirebaseAuth.instance;
    User classeLogada = auth.currentUser;
    String dados = classeLogada.uid;

    final firestoreInstance = FirebaseFirestore.instance;
    firestoreInstance
        .collection("dados_classe")
        .doc(dados)
        .collection("dados")
        .doc(calculo.id)
        .set(
        {
          "data"                 : calculo.data,
          "presenca"             : calculo.presente,
          "estudouBiblia"        : calculo.estudouBiblia,
          "pequenoGrupo"        : calculo.pequenoGrupo,
          "estudoBiblico"        : calculo.estudobiblico,
          "atividadeMissionario" : calculo.atividadeMissionaria


        }).then((_) {
      Future.delayed(Duration(seconds: 0)).then((_) {
        _progresBarLinear = false;
        DateTime date = DateTime.now();
        date = DateTime(date.year, date.month, date.day);
        String data = DateFormat("dd.MM.yyyy").format(date);
        Dados dados = Dados();
        dados.nome = widget._nome;
        dados.data = data;
        _salvarDadosAluno();
        _atualizarData(dados);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Classe(widget._nome, widget._dataBD)));
      });
    });
  }

  _chamarClasse(){
    if (_g == 5) {
      _salvarDados();
    }
  }

  _showAlertDialog(String mensagem, int valor) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Sim", style: TextStyle(color: Colors.blue),),
      onPressed: () {

        switch(valor){
          case 0:
            setState(() => presenca  = !_isButtonDisabled);
            calculo.presente = 1;
            break;
          case 1:
            setState(() => estudouBiblia  = !_isButtonDisabled);
            calculo.estudouBiblia = 1;
            break;
          case 2:
            setState(() => pequenoGrupo  = !_isButtonDisabled);
            calculo.pequenoGrupo = 1;
            break;
          case 3:
            setState(() => estudobiblico  = !_isButtonDisabled);
            calculo.estudobiblico = 1;
            break;
          case 4:
            setState(() => atividadeMissionaria  = !_isButtonDisabled);
            calculo.atividadeMissionaria = 1;
            break;
        }
        Navigator.of(context).pop();
        _g++;
        _chamarClasse();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Não", style: TextStyle(color: Colors.blue)),
      onPressed: () {

        switch(valor){
          case 0:
            setState(() => presenca  = !_isButtonDisabled);
            calculo.presente = 0;
            break;
          case 1:
            setState(() => estudouBiblia  = !_isButtonDisabled);
            calculo.estudouBiblia = 0;
            break;
          case 2:
            setState(() => pequenoGrupo = !_isButtonDisabled);
            calculo.pequenoGrupo = 0;
            break;
          case 3:
            setState(() => estudobiblico  = !_isButtonDisabled);
            calculo.estudobiblico = 0;
            break;
          case 4:
            setState(() => atividadeMissionaria  = !_isButtonDisabled);
            calculo.atividadeMissionaria = 0;
            break;
        }
        Navigator.of(context).pop();
        _g++;
        _chamarClasse();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção"),
      content: Text(mensagem),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _progresBarLinear = false;
    _liberaBotoes();
    fToast = FToast();
    fToast.init(context);
  }

  Future <bool> _sairApp() {
    if (_progresBarLinear == true) {

    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              FechaApp()), (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _sairApp,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff032640),
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,),
          title: Text("Escola sabatina"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: 46),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.live_tv),
                title: Text("Vídeos"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideosPrincipal()),
                  );

                },
              ),
              ListTile(
                leading: Icon(Icons.chrome_reader_mode),
                title: Text("Resumo das Lições"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResumoLicoes()),
                  );

                },
              ),
              ListTile(
                leading: Icon(Icons.announcement_outlined),
                title: Text("Reclamação e sugestão"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReclamacaoSugestao()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text("Sair"),
                onTap: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginAluno( widget._dataBD, nome: '',)),);
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 4),
                    child: Text(widget._nome, style: TextStyle(fontSize: 18),),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage("imagens/logo_cartao.jpg"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: ElevatedButton(
                        child: Text(
                          "Confirmar presença/ausência",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff032640),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        ),
                        onPressed: presenca ? null : () {
                          _showAlertDialog(
                              "Confirma sua presença?", 0
                          );
                        }
                    ),
                  ),
                  Center(
                    child: Text(
                      "COMUNHÃO",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                        child: Text(
                          "Você estudou a Bíblia ou a Lição da Escola Sabatina diariamente?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff032640),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        ),
                        onPressed: estudouBiblia ? null : () {
                          _showAlertDialog(
                              "Você estudou a Bíblia ou a Lição da Escola Sabatina diariamente?", 1
                          );
                        }
                    ),
                  ),
                  Center(
                    child: Text(
                      "RELACIONAMENTO",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Center(
                    child: Container(
                      child: _progresBarLinear ? LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).accentColor, // Red
                        ),
                      ): Center(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: ElevatedButton(
                        child: Text(
                          "Você participou de algum pequeno grupo nesta semana?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff032640),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        ),

                        onPressed: pequenoGrupo ? null : () {
                          _showAlertDialog(
                              "Você participou de algum pequeno grupo nesta semana??", 2
                          );
                        }
                    ),
                  ),
                  Center(
                    child: Text(
                      "MISSÃO",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                        child: Text(
                          "Você deu algum estudo bíblico nesta semana?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff032640),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        ),
                        onPressed: estudobiblico ? null : () {
                          _showAlertDialog(
                              "Você deu algum estudo bíblico nesta semana?", 3
                          );
                        }
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton(
                        child: Text(
                          "Você realizou alguma outra atividade missionária? Ex: Contatos, distribuição de materiais missionários, ações solidárias, etc?",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff032640),
                          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        ),
                        onPressed: atividadeMissionaria ? null : () {
                          _showAlertDialog(
                              "Você realizou alguma outra atividade missionária? Ex: Contatos, distribuição de materiais missionários, ações solidárias, etc?", 4);
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
