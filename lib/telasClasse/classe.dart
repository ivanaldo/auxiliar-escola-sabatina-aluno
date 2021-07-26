import 'package:escola_sabatina_alunos/telas/home.dart';
import 'package:escola_sabatina_alunos/telasClasse/SabadoPassado.dart';
import 'package:escola_sabatina_alunos/telasClasse/hoje.dart';
import 'package:escola_sabatina_alunos/telasClasse/trimestre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Classe extends StatefulWidget {
  final String _nome;
  final String _dataBD;
  Classe(this._nome, this._dataBD);

  @override
  _ClasseState createState() => _ClasseState();
}

class _ClasseState extends State<Classe> {
  int _pageCount = 3;
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(true, widget._nome, widget._dataBD)));
        return true;
          },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff032640),
            title: Text("Escola sabatina"),
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light,),
          ),
          body: _body(),
          bottomNavigationBar: _bottomNavigationBar(),
        )
    );
  }

  Widget _body() {
    return Stack(
      children: List<Widget>.generate(_pageCount, (int index) {
        return IgnorePointer(
          ignoring: index != _pageIndex,
          child: Opacity(
            opacity: _pageIndex == index ? 1.0 : 0.0,
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) {
                return new MaterialPageRoute(
                  builder: (_) => _page(index),
                  settings: settings,
                );
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _page(int index) {
    switch (index) {
      case 0:
        return Hoje();
      case 1:
        return SabadoPassado();
      case 2 :
        return Trimestre();
    }
    throw "Invalid index $index";
  }

  BottomNavigationBar _bottomNavigationBar() {
    final theme = Theme.of(context);
    return new BottomNavigationBar(
      fixedColor: theme.accentColor,
      currentIndex: _pageIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.today),
          label: "Nesse sábado",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Sábado passado",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.whatshot),
          label: "Trimestre",
        ),
      ],
      onTap: (int index) {
        setState(() {
          _pageIndex = index;
        });
      },
    );
  }
}