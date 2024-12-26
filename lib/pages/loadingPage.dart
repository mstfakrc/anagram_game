import 'package:anagram_ladder/models/gameState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _initializeGameState();
  }

  void _initializeGameState() {
    // Pre-load game data
    final gameState = context.read<GameState>();
    gameState.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: "logo",
          child: Image.asset(
            "assets/ag_logo_simple.png",
            height: 200, // Daha uygun bir logo boyutu
            width: 200,
          ),
        ),
      ),
    );
  }
}
