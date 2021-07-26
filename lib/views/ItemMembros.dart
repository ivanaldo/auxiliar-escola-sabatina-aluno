import 'package:escola_sabatina_alunos/contatos/membros.dart';
import 'package:escola_sabatina_alunos/model/Usuarios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemMembros extends StatelessWidget {

  final Usuarios usuario;
  final VoidCallback onTapWhatsapp;
  final VoidCallback onTapTelefone;
  final VoidCallback onPressedRemover;

  ItemMembros({
    @required this.usuario,
    this.onTapTelefone,
    this.onTapWhatsapp,
    this.onPressedRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      usuario.nome,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("Aniversário: "+ usuario.aniversario),
                    Text("Telefone: " + usuario.telefone),
                    Padding(
                      padding: EdgeInsets.only(top: 2,bottom: 2),
                      child: Row(
                        children: [
                          Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4, right: 4),
                                child:  ElevatedButton(
                                  child: Text("Telefonar",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff032640),
                                      padding: EdgeInsets.fromLTRB(28, 16, 28, 16)
                                  ),
                                  onPressed: (){
                                    fazerUmaLigacao(usuario.telefone);
                                    return onTapTelefone;
                                  },
                                ),
                              )
                          ),
                          Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 4, left: 4),
                                child:  ElevatedButton(
                                  child: Text("Whatsapp",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff032640),
                                      padding: EdgeInsets.fromLTRB(28, 16, 28, 16)
                                  ),
                                  onPressed: (){
                                    abrirWhatstapp(usuario.telefone);
                                    return onTapWhatsapp;
                                  },
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}


