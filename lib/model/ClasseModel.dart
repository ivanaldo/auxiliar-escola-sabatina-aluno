
import 'package:cloud_firestore/cloud_firestore.dart';

class ClasseModel {

  String _idIgreja;
  String _idClasse;
  String _nome;
  String _email;
  String _senha;

  ClasseModel();

  ClasseModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    //this.id = documentSnapshot.documentID;
    this.nome      = documentSnapshot["nomeClasse"];
    this.email   = documentSnapshot["emailClasse"];
    this.senha  = documentSnapshot["senhaClasse"];
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

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }
}