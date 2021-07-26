import 'package:escola_sabatina_alunos/model/alunos.dart';
import 'package:flutter/material.dart';

class ItemAlunos extends StatelessWidget {
  final Alunos aluno;

  ItemAlunos({
    @required this.aluno,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Aluno(a): " + aluno.nome,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(

                                aluno.data,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text(aluno.data),
                                  Text(
                                    aluno.presenca,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                          ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text("2"),
                                  Text(
                                    aluno.presenca,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                          ),),
                          Expanded(
                              child: Container(
                                  child: Column(
                                    children: [
                                      Text("3"),
                                      Text(
                                        aluno.presenca,
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                              ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("4"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("5"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("6"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("7"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("8"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("9"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("10"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Expanded(
                            child: Container(
                                child: Column(
                                  children: [
                                    Text("11"),
                                    Text(
                                      aluno.presenca,
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            ),
                          ),
                         Expanded(
                           child:  Container(
                             child: Column(
                               children: [
                                 Text("12"),
                                 Text(
                                   aluno.presenca,
                                   style: TextStyle(
                                       fontSize: 16, fontWeight: FontWeight.bold),
                                 ),
                               ],
                             )
                         ),
                         ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: [
                                  Text("13"),
                                  Text(
                                    aluno.presenca,
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                          ),
                          )
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
