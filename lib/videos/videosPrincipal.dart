import 'package:escola_sabatina_alunos/videos/informativo.dart';
import 'package:escola_sabatina_alunos/videos/provai.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class VideosPrincipal extends StatefulWidget {
  @override
  _VideosPrincipalState createState() => _VideosPrincipalState();
}

class _VideosPrincipalState extends State<VideosPrincipal>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
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
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(
              text: "Provai e Vede",
            ),
            Tab(
              text: "Informativo",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[Provai(), Informativo()],
      ),
    );
  }
}