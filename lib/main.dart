import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Pages/tic_tac_toe_page.dart';
import 'Provider/game_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child:  TicTacToeApp(),
    ),
  );
}

class TicTacToeApp extends StatelessWidget {
   TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home:  TicTacToePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
