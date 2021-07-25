import 'package:escola_sabatina_alunos/videos/licaoAdolescente.dart';
import 'package:escola_sabatina_alunos/videos/licaoAdulto.dart';
import 'package:escola_sabatina_alunos/videos/licaoJovem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ResumoLicoes extends StatefulWidget {
  @override
  _ResumoLicoesState createState() => _ResumoLicoesState();
}

class _ResumoLicoesState extends State<ResumoLicoes>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff032640),
        title: Text('Escola Sabatina'),
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 15.5, fontWeight: FontWeight.normal),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Adulto",
            ),
            Tab(
              text: "Jovem",
            ),
            Tab(
              text: "Adolescente",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[LicaoAdulto(), LicaoJovem(), LicaoAdolescente()],
      ),
    );
  }
}