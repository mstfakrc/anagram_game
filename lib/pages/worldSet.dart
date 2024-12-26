import 'dart:math';
import 'package:anagram_ladder/models/gameState.dart';
import 'package:anagram_ladder/navigation/gameRouteNavigator.dart';
import 'package:anagram_ladder/navigation/gameRoutePath.dart';
import 'package:anagram_ladder/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorldSetPage extends StatelessWidget {
  const WorldSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PICK YOUR DIFFICULTY"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Center(
          child: _buildWorldGrid(context),
        ),
      ),
    );
  }

  Widget _buildWorldGrid(BuildContext context) {
    final isPortrait = shouldTreatAsPortrait(context);
    final buttons = GameState.worldIds
        .map((worldNum) => _buildWorldButton(context, worldNum))
        .toList();

    return GridView.count(
      crossAxisCount: isPortrait ? 1 : 2,
      childAspectRatio: isBigScreen(context) ? 3 : 4,
      padding: const EdgeInsets.all(16.0),
      children: buttons,
    );
  }

  Widget _buildWorldButton(BuildContext context, int worldNum) {
    final navigator = context.read<GameRouteNavigator>();
    final gameState = context.read<GameState>();
    final label = GameState.worldLabels[worldNum];
    final completionInfo = gameState.getWorldCompletionInfo(worldNum);
    final textScaleFactor = min(1.3, MediaQuery.of(context).textScaleFactor);

    return GestureDetector(
      onTap: () => navigator.goto(GameRoutePath.world(worldNum)),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label!,
              textScaleFactor: textScaleFactor,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "${completionInfo.completedCount} / ${completionInfo.levelCount}",
              textScaleFactor: textScaleFactor,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
