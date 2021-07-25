import 'package:escola_sabatina_alunos/telas/splashP.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext contextP) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashP(),
      theme: ThemeData(
          accentColor: Color(0xff032640)),
    );
  }
}