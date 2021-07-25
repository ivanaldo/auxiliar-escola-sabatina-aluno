import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/model/CalculoDados.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SabadoPassado extends StatefulWidget {
  @override
  _SabadoPassadoState createState() => _SabadoPassadoState();
}

bool _progresBarLinear;
NumberFormat formatter = NumberFormat("0.0");
FirebaseAuth auth = FirebaseAuth.instance;
User user = auth.currentUser;
int _membros = 0;
double _presenca = 0.0;
double _estudouBiblia = 0.0;
double _pequenoGrupo = 0.0;
double _estudoBiblico = 0.0;
double _atividadeMissionario = 0.0;

int presenca = 0;
int estudouBiblia = 0;
int pequenoGrupo = 0;
int atividadeMissionario = 0;
int estudoBiblico = 0;

Color corPresenca;
Color corEstudouBiblia;
Color corPequenoGrupo;
Color corEstudoBiblico;
Color corAtividadeMissionaria;

List<String> datas = [];

CalculoDados dados = new CalculoDados();

class _SabadoPassadoState extends State<SabadoPassado> {

  //retorna quantos membros tem na classe
  Future<dynamic> _retornaMembros() async {
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

  void _datas(){
    for(int i = 1; i <= 7; i++) {
      DateTime date = DateTime.now();
      date = DateTime(date.year, date.month, date.day - i);
      datas.add(DateFormat("dd/MM/yyyy").format(date));
    }
  }

  Future<dynamic>_calculaDadosMembros() async {
    String usuario = user.uid;
    var dadosMembros;

    presenca = 0;
    estudouBiblia = 0;
    pequenoGrupo = 0;
    estudoBiblico = 0;
    atividadeMissionario = 0;

    for (int i = 0; i < datas.length; i++){
      FirebaseFirestore db = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await db
          .collection("dados_classe")
          .doc(usuario)
          .collection("dados")
          .where("data", isEqualTo: datas[i])
          .get();

      for (DocumentSnapshot dados in querySnapshot.docs) {
        if(dados.exists) {
          dadosMembros = dados.data();
          setState(() {
            presenca += dadosMembros["presenca"];
            estudouBiblia += dadosMembros["estudouBiblia"];
            pequenoGrupo += dadosMembros["pequenoGrupo"];
            estudoBiblico += dadosMembros["estudoBiblico"];
            atividadeMissionario += dadosMembros["atividadeMissionario"];

            _presenca = (presenca * 100) / _membros;
            _estudouBiblia = (estudouBiblia * 100) / _membros;
            _pequenoGrupo = (pequenoGrupo * 100) / _membros;
            _estudoBiblico = (estudoBiblico * 100) / _membros;
            _atividadeMissionario = (atividadeMissionario * 100) / _membros;

            _corPresenca();
            _corEstudouBiblia();
            _corPequenoGrupo();
            _corEstudoBiblico();
            _corAtividadeMissionario();

          });
        }
      }
    }
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
    _datas();
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
                  child: Text("Situação da classe no sábado passado", style: TextStyle(fontSize: 16),),
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
                        "12 ",
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
                padding: EdgeInsets.only(top: 20, bottom: 4),
                child: Text("Membros presentes na semana passada", style: TextStyle(fontSize: 16),
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
                    child: Text(
                      " $presenca ",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Text("Total de "+ formatter.format(_presenca)+"%", style: TextStyle(fontSize: 16),),
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
                      style: TextStyle(fontSize: 18),
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
                      style: TextStyle(fontSize: 18),
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
                child: Text("Membros que deram estudos bíblicos", style: TextStyle(fontSize: 16),
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
                      style: TextStyle(fontSize: 18),
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
                child: Text("Membros que realizaram atividades missionária", style: TextStyle(fontSize: 16),
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
                      style: TextStyle(fontSize: 18),
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
