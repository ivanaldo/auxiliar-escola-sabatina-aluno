import 'package:escola_sabatina_alunos/telas/splash.dart';
import 'package:flutter/material.dart';


class SplashP extends StatefulWidget {
  @override
  _SplashPState createState() => _SplashPState();
}

class _SplashPState extends State<SplashP> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((_) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('imagens/logo_igreja.png', height: 300, width: 300),
      ),
    );
  }
}
