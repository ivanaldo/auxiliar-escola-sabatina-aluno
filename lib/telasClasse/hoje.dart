import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/model/CalculoDados.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Hoje extends StatefulWidget {
  @override
  _HojeState createState() => _HojeState();
}

bool _progresBarLinear;
NumberFormat formatter = NumberFormat("0.0");
int _membros;
double _presenca = 0.0;
double _estudouBiblia = 0.0;
double _pequenoGrupo = 0.0;
double _estudoBiblico = 0.0;
double _atividadeMissionario = 0.0;

int presenca = 0;
int estudouBiblia = 0;
int pequenoGrupo = 0;
int estudoBiblico = 0;
int atividadeMissionario = 0;

Color corPresenca;
Color corEstudouBiblia;
Color corPequenoGrupo;
Color corEstudoBiblico;
Color corAtividadeMissionaria;

CalculoDados dados = new CalculoDados();

class _HojeState extends State<Hoje> {

  //retorna quantos membros tem na classe
  Future<dynamic> _retornaMembros() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    String usuario = user.uid;

    _membros = 0;
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("alunos_classe")
        .doc(usuario)
        .collection("alunos")
        .get();
    for (DocumentSnapshot dados in querySnapshot.docs) {
      if (dados.exists) {
        setState(() {
          _progresBarLinear = false;
          _membros++;
        });
      }
    }
    _calculaDadosMembros();
  }

  Future<dynamic>_calculaDadosMembros() async {
    DateTime datas = DateTime.now();
    String data = DateFormat("dd/MM/yyyy").format(datas);
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    String usuario = user.uid;
    bool liberaCor = false;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("dados_classe")
        .doc(usuario)
        .collection("dados")
        .where("data", isEqualTo: data)
        .snapshots().listen((snapshot) {

      presenca = 0;
      estudouBiblia = 0;
      pequenoGrupo = 0;
      estudoBiblico = 0;
      atividadeMissionario = 0;

      _presenca = 0.0;
      _estudouBiblia = 0.0;
      _pequenoGrupo = 0.0;
      _estudoBiblico = 0.0;
      _atividadeMissionario = 0.0;

      corPresenca = Colors.transparent;
      corEstudouBiblia = Colors.transparent;
      corPequenoGrupo = Colors.transparent;
      corEstudoBiblico = Colors.transparent;
      corAtividadeMissionaria = Colors.transparent;

      for (DocumentSnapshot dados in snapshot.docs) {
        if(dados.exists) {
          setState(() {
            liberaCor = true;
            presenca             += dados["presenca"];
            estudouBiblia        += dados["estudouBiblia"];
            pequenoGrupo        += dados["pequenoGrupo"];
            estudoBiblico        += dados["estudoBiblico"];
            atividadeMissionario += dados["atividadeMissionario"];

            _presenca             = (presenca*100)/_membros;
            _estudouBiblia        = (estudouBiblia*100)/_membros;
            _pequenoGrupo        = (pequenoGrupo*100)/_membros;
            _estudoBiblico        = (estudoBiblico*100)/_membros;
            _atividadeMissionario = (atividadeMissionario*100)/_membros;

          });
        }
      }
      if (liberaCor == true) {
        setState(() {
          _corPresenca();
          _corEstudouBiblia();
          _corPequenoGrupo();
          _corEstudoBiblico();
          _corAtividadeMissionario();
          liberaCor = false;
        });
      }
    });

  }

  _corPresenca(){
    setState(() {
      if(_presenca <= 49){
        corPresenca = Colors.red;
      }else if(_presenca == 50 || _presenca <= 69){
        corPresenca = Colors.yellow;
      }else if(_presenca == 70 || _presenca <= 89){
        corPresenca = Colors.blue;
      }else{
        corPresenca = Colors.green;
      }
    });
  }

  _corEstudouBiblia(){
    setState(() {
      if(_estudouBiblia <= 49){
        corEstudouBiblia = Colors.red;
      }else if(_estudouBiblia == 50 || _estudouBiblia <= 69){
        corEstudouBiblia = Colors.yellow;
      }else if(_estudouBiblia == 70 || _estudouBiblia <= 89){
        corEstudouBiblia = Colors.blue;
      }else{
        corEstudouBiblia = Colors.green;
      }
    });
  }

  _corPequenoGrupo(){
    setState(() {
      if(_pequenoGrupo <= 49){
        corPequenoGrupo = Colors.red;
      }else if(_pequenoGrupo == 50 || _pequenoGrupo <= 69){
        corPequenoGrupo = Colors.yellow;
      }else if(_pequenoGrupo == 70 || _pequenoGrupo <= 89){
        corPequenoGrupo = Colors.blue;
      }else{
        corPequenoGrupo = Colors.green;
      }
    });
  }
  _corAtividadeMissionario(){
    setState(() {
      if(_atividadeMissionario <= 49){
        corAtividadeMissionaria = Colors.red;
      }else if(_atividadeMissionario == 50 || _atividadeMissionario <= 69){
        corAtividadeMissionaria = Colors.yellow;
      }else if(_atividadeMissionario == 70 || _atividadeMissionario <= 89){
        corAtividadeMissionaria = Colors.blue;
      }else{
        corAtividadeMissionaria = Colors.green;
      }
    });
  }

  _corEstudoBiblico(){
    setState(() {
      if(_estudoBiblico <= 49){
        corEstudoBiblico = Colors.red;
      }else if(_estudoBiblico == 50 || _estudoBiblico <= 69){
        corEstudoBiblico = Colors.yellow;
      }else if(_estudoBiblico == 70 || _estudoBiblico <= 89){
        corEstudoBiblico = Colors.blue;
      }else{
        corEstudoBiblico = Colors.green;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _progresBarLinear = true;
    _retornaMembros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Row(children: [
                Padding(
                  padding: EdgeInsets.only( right: 8),
                  child: Text("Total de membros na classe", style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(

                  ),
                  child: Center(
                    child: Text(
                      "$_membros",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
              ),
              Padding(padding: EdgeInsets.only(top: 36, bottom: 36),
                child: Center(
                  child: Text("Situação da classe nesse sábado", style: TextStyle(fontSize: 16),),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 8),
                  child: _progresBarLinear ? LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).accentColor, // Red
                    ),
                  ): Center(),
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.green),],
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        "12",
                        style: TextStyle(fontSize: 10, color: Colors.transparent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Text("Ótimo", style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.blue),],
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        "12 ",
                        style: TextStyle(fontSize: 10, color: Colors.transparent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Text("Bom", style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.yellow),],
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        "12 ",
                        style: TextStyle(fontSize: 10, color: Colors.transparent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Text("Razoável", style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.red),],
                        border: Border.all(
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        "12 ",
                        style: TextStyle(fontSize: 10, color: Colors.transparent),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Text("Ruim", style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, bottom: 4),
                child: Text("Membros presentes hoje", style: TextStyle(fontSize: 16),
                ),
              ),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      color: corPresenca,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(" $presenca ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_presenca)+"%", style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              ),

              const Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 4),
                child: Text("Membros que estudaram a Bíblia ou a Lição", style: TextStyle(fontSize: 16),
                ),
              ),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      color: corEstudouBiblia,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(
                      " $estudouBiblia ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_estudouBiblia)+"%", style: TextStyle(fontSize: 16),),
                ),
              ],
              ),

              const Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 4),
                child: Text("Membros que participaram de algum pequeno grupo", style: TextStyle(fontSize: 16),
                ),
              ),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      color: corPequenoGrupo,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(
                      " $pequenoGrupo ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_pequenoGrupo)+"%", style: TextStyle(fontSize: 16),),
                ),
              ],
              ),
              const Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 4),
                child: Text("Membros que deram estudos Bíblico", style: TextStyle(fontSize: 16),
                ),
              ),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      color: corEstudoBiblico,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(
                      " $estudoBiblico ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_estudoBiblico)+"%", style: TextStyle(fontSize: 16),),
                ),
              ],
              ),
              const Divider(
                color: Colors.grey,
                height: 15,
                thickness: 2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 4),
                child: Text("Membros que realizaram atividades missionárias", style: TextStyle(fontSize: 16),
                ),
              ),
              Row(children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      color: corAtividadeMissionaria,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Center(
                    child: Text(
                      " $atividadeMissionario ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_atividadeMissionario)+"%", style: TextStyle(fontSize: 16),),
                ),
              ],
              ),
              Padding(
                  padding: EdgeInsets.only(bottom: 8)
              )
            ],
          ),
        ),
      ),
    );
  }
}
