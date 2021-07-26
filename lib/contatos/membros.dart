import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/model/Usuarios.dart';
import 'package:escola_sabatina_alunos/views/ItemMembros.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Membros extends StatefulWidget {
  @override
  _MembrosState createState() => _MembrosState();
}

fazerUmaLigacao(String telefone) async{
  var url = "tel:$telefone";
  if(await canLaunch(url)){
    await launch(url);
  }else
    throw 'Esse  numero $url não existe';
}

abrirWhatstapp(String telefone) async {
  var whatsappUrl = "whatsapp://send?phone=+55$telefone";
  if(await canLaunch(whatsappUrl)){
    await launch(whatsappUrl);
  }else
    throw 'Esse número $whatsappUrl não existe';
}

class _MembrosState extends State<Membros> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  //recupera o id do usuario logado
  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = auth.currentUser;
    _idUsuarioLogado = usuarioLogado.uid;

  }

  //recupera a lista de membros da classe com base no id do usuario
  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {

    await _recuperaDadosUsuarioLogado();

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("alunos_classe")
        .doc( _idUsuarioLogado )
        .collection("alunos")
        .snapshots();

        stream.listen((dados){
       _controller.add( dados );
    });

  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Container(
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).accentColor, // Red
              ),
            ),
          ),
        ),
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Membros da classe"),
        backgroundColor: Color(0xff032640),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,),
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){

          switch( snapshot.connectionState ){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados;
              break;
            case ConnectionState.active:
            case ConnectionState.done:

            //Exibe mensagem de erro
              if(snapshot.hasError)
                return Text("Erro ao carregar os dados!");

              QuerySnapshot querySnapshot = snapshot.data;

              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, indice){

                    List<DocumentSnapshot> usuarios = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = usuarios[indice];
                    Usuarios usuario = Usuarios.fromDocumentSnapshot(documentSnapshot);

                    return ItemMembros(
                      usuario: usuario,
                      onTapTelefone: (){
                      },
                      onTapWhatsapp: (){
                      },
                    );
                  }
              );
          }
          return Container();
        },
      ),
    );
  }
}

