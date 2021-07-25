import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FechaApp extends StatefulWidget {
  @override
  _FechaAppState createState() => _FechaAppState();
}

class _FechaAppState extends State<FechaApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1)).then((_) {
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset('imagens/logo_escola.png', height: 300, width: 300),

        ),
      ),
    );
  }
}