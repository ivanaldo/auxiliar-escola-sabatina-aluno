import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/model/alunos.dart';
import 'package:escola_sabatina_alunos/views/ItemAlunos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlunosClasse extends StatefulWidget {

  @override
  _AlunosClasseState createState() => _AlunosClasseState();
}

class _AlunosClasseState extends State<AlunosClasse> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  //recupera a lista de alunos da classe
  Future<Stream<QuerySnapshot>> _adicionarListenerAnuncios() async {

    var usuario = FirebaseAuth.instance.currentUser;
    String idClasse = usuario.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("alunos")
        .where("idClasse", isEqualTo: idClasse)
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
        title: Text("Presença  dos alunos"),
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

                    List<DocumentSnapshot> aluno = querySnapshot.docs.toList();
                    DocumentSnapshot documentSnapshot = aluno[indice];
                    Alunos alunos = Alunos.fromDocumentSnapshot(documentSnapshot);

                    return ItemAlunos(
                      aluno: alunos,
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

