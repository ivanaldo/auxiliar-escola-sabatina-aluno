import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Professor extends StatefulWidget {
  @override
  _ProfessorState createState() => _ProfessorState();
}

String _nome = "";
String _telefone = "";
String _aniversario = "";
bool _progresBarLinear;

_fazerUmaLigacao() async{
  var url = "tel:$_telefone";
  if(await canLaunch(url)){
    await launch(url);
  }else
    throw 'Esse  numero $url não existe';
}

_abrirWhatstapp() async {
  var whatsappUrl = "whatsapp://send?phone=+55$_telefone";
  if(await canLaunch(whatsappUrl)){
    await launch(whatsappUrl);
  }else
    throw 'Esse número $whatsappUrl não existe';
}

class _ProfessorState extends State<Professor> {

  @override
  void initState() {
    super.initState();
    _progresBarLinear = true;
    _retornaDados();
  }

  Future<dynamic> _retornaDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    String usuario = user.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("professor")
        .doc(usuario)
        .get()
        .then((dados){
      setState(() {
        _nome = dados["nome"];
        _telefone = dados["telefone"];
        _aniversario = dados["aniversario"];

        _progresBarLinear = false;

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff032640),
        title: Text("Escola Sabatina"),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("imagens/logo_professor.jpg"),
                ),
              ),
              Center(
                child: Text(
                  "Professor(a):",
                  style: TextStyle(fontSize: 18),
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
                padding: EdgeInsets.only(top:16, bottom: 16),
                child: Text(
                  "$_nome",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  "Aniversário:",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                    "$_aniversario",
                    style: TextStyle(fontSize: 14)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                    "Telefone: " + _telefone,
                    style: TextStyle(fontSize: 14)
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                    child: Text(
                      "Telefonar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff032640),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    ),

                    onPressed: (){
                      _fazerUmaLigacao();
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                    child: Text(
                      "Whatsapp",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xff032640),
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    ),

                    onPressed: (){
                      _abrirWhatstapp();
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

