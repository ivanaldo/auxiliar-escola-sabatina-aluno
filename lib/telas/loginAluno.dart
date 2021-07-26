import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escola_sabatina_alunos/model/bancoDados.dart';
import 'package:escola_sabatina_alunos/model/dadosModel.dart';
import 'package:escola_sabatina_alunos/telas/fechaApp.dart';
import 'package:escola_sabatina_alunos/telas/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginAluno extends StatefulWidget {
  @override
  _LoginAlunoState createState() => _LoginAlunoState();
}

class _LoginAlunoState extends State<LoginAluno> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerNome = TextEditingController();

  FToast fToast;
  bool _progresBarLinear = false;
  String _nomeBD;
  String nomeController;
  String _dataBD;
  String id;

  @override
  void initState() {
    super.initState();
    _recuperarDados();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    _controllerNome.dispose();
    super.dispose();
  }

  var _db = BancoDados();

  Future _recuperarDados() async {

    List nomeRecuperado = await _db.recuperarDados();
    for (var item in nomeRecuperado) {
      setState(() {
        _nomeBD   = item["nome"];
        _dataBD = item["data"];

          _progresBarLinear = false;

      });
    }
  }

  _validarCampos() {
    //Recupera dados dos campos
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        if (_nomeBD == "N/D") {
          setState(() {
            _progresBarLinear = true;
          });
          _nomeMembro(email, senha);
        } else {
          setState(() {
            _progresBarLinear = true;
          });
          _retornaEmail(email, senha);
        }
      } else {
        Widget toast = Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.black45,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12.0,
              ),
              Text(
                "Preencha a sua senha de acesso, ela tem que ter mais de seis caracteres!",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        );
        fToast.showToast(
          child: toast,
          gravity: ToastGravity.TOP,
          toastDuration: Duration(seconds: 2),
        );
      }
    } else {
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.0,
            ),
            Text(
              "Preencha o seu email de acesso!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 2),
      );
    }
  }
  //atualiza o nome no banco de dados, chama a função para verificar se o email existe
  //e chama a função para recuperar novamente os dados do banco
  _atualizarNome(Dados dados, String email, String senha) async {
    _db.atualizarNome(dados);
    _retornaEmail(email, senha);
    _recuperarDados();
  }
  //retornar o id da classe se ela existir, se não retornar mensagem ao usuário que classe não existi
  Future<dynamic> _retornaIdClasse(String email, String senha) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("classes")
        .limit(1)
        .where("emailClasse", isEqualTo: email)
        .get();
    for (DocumentSnapshot dados in querySnapshot.docs) {
      if(dados.exists){
        setState(() {
          id = dados["idClasse"];
        });
      }
    }
    if(id != null){
      _retornaNome(email, senha);
    }else{
      setState(() {
        _progresBarLinear = false;
      });
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.0,
            ),
            Text(
              "Essa classe não existe ou tem algum problema com sua internet!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 4),
      );
    }
  }
  //confere se o usuário pertence a classe, se não avisa ao usuário pra entrar somente na sua classe
  Future<dynamic> _retornaNome(String email, String senha) async {

    final QuerySnapshot result = await Future.value(FirebaseFirestore.instance
        .collection("alunos_classe")
        .doc(id)
        .collection("alunos")
        .where("nome", isEqualTo: _nomeBD)
        .get());
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      setState(() {
        _progresBarLinear = false;
      });
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.0,
            ),
            Text(
              "Esse usuário não pertence a essa classe, entre somente em sua classe!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 4),
      );
    } else {
      _logarUsuario(email, senha);
    }
  }
  //confere se o email passado é de uma classe ou uma igreja, se for de uma igreja avisa
  // ao usuário para entrar com o email de uma classe e não de uma igreja
  Future<dynamic> _retornaEmail(String email, String senha) async {
    final QuerySnapshot result = await Future.value(FirebaseFirestore.instance
        .collection("igrejas")
        .where("emailIgreja", isEqualTo: email)
        .limit(1)
        .get());
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      setState(() {
        _progresBarLinear = false;
      });
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.0,
            ),
            Text(
              "Essa conta é de uma igreja, por favor entre com a conta de uma classe!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 4),
      );
    } else {
      _retornaIdClasse(email, senha);
    }
  }
//responsável por logar usuário e mandalo para a tela Home do aplicativo
  _logarUsuario(String email, String senha) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(email: email, password: senha).then((firebaseUser) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Home(false, _nomeBD, _dataBD)));
    }).catchError((error) {
      setState(() {
        _progresBarLinear = false;
      });
      Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.black45,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12.0,
            ),
            Text(
              "Algum problema com seus dados ou com sua internet!",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 3),
      );
    });
  }
  //responsável por cadastrar o nome do usuário no aplicativo
  _nomeMembro(String email, String senha) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('É preciso informar o seu nome! Esse nome não será mudado, por favor confira'
              ' se o nome está correto!'),
          content: new Row(
            children: [
              new Expanded(
                  child: new TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    maxLength: 14,
                    decoration: new InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(52, 6, 52, 6),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6))),
                  ))
            ],
          ),
          actions: [
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                setState(() {
                  nomeController = _controllerNome.text.trim();
                });

                if (nomeController.isNotEmpty) {
                  Dados dados = Dados();
                  dados.nome = nomeController;
                  dados.data = _dataBD;
                  _atualizarNome(dados, email, senha);

                  Navigator.of(context).pop();
                } else {
                  Widget toast = Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.black45,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 12.0,
                        ),
                        Text("Insira um nome válido!",
                            style:
                            TextStyle(color: Colors.white, fontSize: 20)),
                      ],
                    ),
                  );
                  fToast.showToast(
                    child: toast,
                    gravity: ToastGravity.TOP,
                    toastDuration: Duration(seconds: 2),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Fechar'),
              onPressed: () {
                Widget toast = Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Colors.black45,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12.0,
                      ),
                      Text("É preciso informar seu nome para ter acesso!",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                );

                fToast.showToast(
                  child: toast,
                  gravity: ToastGravity.TOP,
                  toastDuration: Duration(seconds: 2),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FechaApp()),
                (Route<dynamic> route) => false);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Escola sabatina"),
            backgroundColor: Color(0xff032640),
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.light,
            ),
          ),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 32),
                        child: Image.asset(
                          "imagens/logo_igreja.png",
                          width: 200,
                          height: 200,
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
                        padding: EdgeInsets.only(top: 8, right: 16, left: 16),
                        child: TextField(
                          controller: _controllerEmail,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "e-mail",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                        ),
                      ),
                      Padding(
                        padding:EdgeInsets.only(right: 16, left: 16),
                        child: TextField(
                          controller: _controllerSenha,
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                              hintText: "senha",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 42, right: 16, left: 16),
                        child: ElevatedButton(
                            child: Text(
                              "Entrar",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF032640),
                              padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            ),
                            onPressed: () {
                              _validarCampos();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}
