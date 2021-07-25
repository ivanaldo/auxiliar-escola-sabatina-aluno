
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios{

  String _id;
  String _idIgreja;
  String _idClasse;
  String _nome;
  String _telefone;
  String _aniversario;

  Usuarios();

  Usuarios.gerarId(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usuario = db.collection("classes");
    //this.id = usuario.doc().documentID;
  }

  Usuarios.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id           = documentSnapshot.id;
    this.nome         = documentSnapshot["nome"];
    this.telefone     = documentSnapshot["telefone"];
    this.aniversario  = documentSnapshot["aniversario"];

  }

  String get idIgreja => _idIgreja;

  set idIgreja(String value) {
    _idIgreja = value;
  }

  String get idClasse => _idClasse;
  set idClasse(String value) {
    _idClasse = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get aniversario => _aniversario;

  set aniversario(String value) {
    _aniversario = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}