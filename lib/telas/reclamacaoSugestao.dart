import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ReclamacaoSugestao extends StatefulWidget {
  @override
  _ReclamacaoSugestaoState createState() => _ReclamacaoSugestaoState();
}

class _ReclamacaoSugestaoState extends State<ReclamacaoSugestao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff032640),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,),
        title: Text("Escola sabatina"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container (
                    width: 140,
                    height: 140,
                    child: Image.asset("imagens/logo_icm.png"),
                  ),
                ),
                Center(
                  child: Text("O aplicativo escola sabatina foi desenvolvido com o intuito de alertar aos irmãos sobre o quanto estamos trabalhando para o"
                      " nosso desenvolvimento como corpo de Cristo e salvação de almas, nunca devemos nos esquecer que a escola sabatina foi e é "
                      " um plano de Deus para o crescimento espiritual de sua igreja. Esperamos com que o mesmo aplicativo possa alerta-los quanto a sua situação"
                      " espiritual e de sua igreja e possa auxilia-los para o seu crescimento espiritualmente!",
                    textAlign: TextAlign.justify,
                    style: TextStyle( fontSize: 16 ),
                  ),
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(top: 32),
                    child:  Text("Desenvolvido pela icm technology mobile",
                      style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(padding: EdgeInsets.only(top:8),
                    child:  Text("Contatos",
                      style: TextStyle( fontSize: 16),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top:8),
                  child:  Text("Email: ivanaldogc@gmail.com",
                    style: TextStyle( fontSize: 16),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top:8),
                  child:  Text("Telefone/Whatsapp: (75) 9 9999-6044",
                    style: TextStyle( fontSize: 16),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top:8, bottom: 8),
                  child:  Text("Versão. 1.0",
                    style: TextStyle( fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
