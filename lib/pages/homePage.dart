import 'dart:math';
import 'package:anagram_ladder/navigation/gameRouteNavigator.dart';
import 'package:anagram_ladder/navigation/gameRoutePath.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final windowSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Hero(
                  tag: "logo",
                  child: ConstrainedBox(
                    constraints: isPortrait
                        ? BoxConstraints.loose(Size.fromWidth(windowSize.width * 0.8))
                        : BoxConstraints.loose(Size.fromHeight(150)),
                    child: Image.asset("assets/ag_logo_wide.png"),
                  ),
                ),
                const SizedBox(height: 20),

                // Play Button
                _playButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _playButton(BuildContext context) {
    final textScaleFactor = min(1.4, MediaQuery.of(context).textScaleFactor);
    final nav = context.read<GameRouteNavigator>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, // Text color
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      onPressed: () => nav.goto(GameRoutePath.worldSet()),
      child: Text(
        "Play",
        style: TextStyle(
          fontSize: 24 * textScaleFactor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
