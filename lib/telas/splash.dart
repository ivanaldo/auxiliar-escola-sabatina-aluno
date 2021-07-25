import 'dart:async';
import 'package:escola_sabatina_alunos/model/bancoDados.dart';
import 'package:escola_sabatina_alunos/telas/consentimento.dart';
import 'package:escola_sabatina_alunos/telas/home.dart';
import 'package:escola_sabatina_alunos/telas/loginAluno.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}
String _nome = "";
String _dataBD = "";
String _permissao ="";

class _SplashState extends State<Splash> {


  var _db = BancoDados();

  Future _recuperarDados() async {

    List dataRecuperada = await _db.recuperarDados();
    for( var item in dataRecuperada ){
      setState(() {

        _nome      = item["nome"];
        _permissao = item["permissao"];
        _dataBD    = item["data"];
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _recuperarDados();

    Future.delayed(Duration(seconds: 4)).then((_) {

      User usuarioLogado = FirebaseAuth.instance.currentUser;

      if(_permissao == "negada"){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Consentimento(_dataBD, _nome)));
      }else{
        if( usuarioLogado != null ){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home(false, _nome, _dataBD )));
        }else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginAluno( _dataBD, nome: _nome)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('imagens/logo_escola.png', height: 300, width: 300),
      ),
    );
  }
}
