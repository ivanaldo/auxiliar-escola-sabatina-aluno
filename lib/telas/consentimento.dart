import 'package:escola_sabatina_alunos/model/bancoDados.dart';
import 'package:escola_sabatina_alunos/model/dadosModel.dart';
import 'package:escola_sabatina_alunos/telas/fechaApp.dart';
import 'package:escola_sabatina_alunos/telas/loginAluno.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


class Consentimento extends StatefulWidget {
  final String _data;
  final String _nome;
  Consentimento(this._data, this._nome);

  @override
  _ConsentimentoState createState() => _ConsentimentoState();
}

class _ConsentimentoState extends State<Consentimento> {
  BuildContext _dialogContext;

  Dados dados = Dados();

  var _db = BancoDados();

  _permissao(Dados dadosAtual) async {

    _db.atualizarNome(dadosAtual);

    Navigator.pop(_dialogContext);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginAluno()));

  }


  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0)).then((_){
      _abrirDialog( _dialogContext );
    });

  }

  _abrirDialog(BuildContext context){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20,),
                Text("O aplicativo precisa usar alguns dados seu como nome, telefone e data de aniversário, portanto para poder utilizar o mesmo é necessário "
                    "a sua permissão para o uso desses dados pelo aplicativo. Clicando em permitir você concorda em dar permissão para o uso de seus dados."),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: (){
                          dados.nome = widget._nome;
                          dados.permissao = "permitido";
                          dados.data = widget._data;
                          _permissao(dados);
                        },
                        child: Text("Permitir"),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(_dialogContext);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FechaApp()));
                        },
                        child: Text("Não permitir"),
                      ),
                    ],
                  ),
                )

              ],
            ),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    return Scaffold(
      body: Center(
        //child: Image.asset("imagens/ja.png"),
      ),
    );
  }
}

