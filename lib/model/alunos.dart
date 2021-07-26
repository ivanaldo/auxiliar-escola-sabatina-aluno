import 'package:cloud_firestore/cloud_firestore.dart';

class Alunos{
  String _nome;
  String _presenca;
  String _data;

  Alunos();


  Alunos.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    //this.id = documentSnapshot.documentID;
    this._nome      = documentSnapshot["nome"];
    this._presenca  = documentSnapshot["presenca"];
    this._data      = documentSnapshot["data"];

  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get presenca => _presenca;

  set presenca(String value) {
    _presenca = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }
}