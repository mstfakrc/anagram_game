import 'dart:math';

import 'package:anagram_ladder/models/gameState.dart';
import 'package:anagram_ladder/navigation/gameRouteNavigator.dart';
import 'package:anagram_ladder/navigation/gameRoutePath.dart';
import 'package:anagram_ladder/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorldPage extends StatefulWidget {
  final int world;

  WorldPage(this.world);

  @override
  State<StatefulWidget> createState() => _WorldPageState();
}

class _WorldPageState extends State<WorldPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    final state = context.read<GameState>();

    // Pre-load the world
    state.getWorldOrLoad(widget.world).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = GameState.worldLabels[widget.world];
    return Scaffold(
      appBar: AppBar(title: Text("$label Ladders"),centerTitle: true,),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(bottom: 0, top: 5),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator(semanticsLabel: "Loading...")
                : _gridView(context),
          ),
        ),
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    final isPortrait = shouldTreatAsPortrait(context);
    final nav = context.read<GameRouteNavigator>();
    final gameState = context.read<GameState>();
    final advertiseMoreLevels = gameState.shouldAdverstiseMoreLevels;
    final maxLevelCount = gameState.maxLevelsPerWorld;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isPortrait ? 4 : 6,
        childAspectRatio: 1,
      ),
      itemCount: advertiseMoreLevels ? maxLevelCount + 1 : maxLevelCount,
      itemBuilder: (BuildContext ctx, index) {
        return Center(
          child: index == maxLevelCount
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _advertiseButton(context, nav),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: _levelButton(context, index + 1, nav, gameState),
                  ),
                ),
        );
      },
    );
  }

  Widget _advertiseButton(
    BuildContext context,
    GameRouteNavigator nav,
  ) {
    final textScaleFactor = min(1.0, MediaQuery.of(context).textScaleFactor);

    return OutlinedButton(
      onPressed: () {
        nav.goto(GameRoutePath.pay(
            source: GameRoutePage.World, world: widget.world));
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: const BorderSide(color: Colors.teal),
      ),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(2),
          child: Text(
            'Unlock more levels!',
            textScaleFactor: textScaleFactor,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _levelButton(BuildContext context, int index, GameRouteNavigator nav,
      GameState gameState) {
    final textScaleFactor = min(1.5, MediaQuery.of(context).textScaleFactor);
    final levelState = gameState.getLevelState(widget.world, index);

    final filledSegments = (levelState.percentComplete * 10).round();
    final gradientColors = [
      for (int i = 0; i < 10; i++)
        i < filledSegments ? Colors.greenAccent : Colors.grey.shade300
    ];

    final partialGradientDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: gradientColors,
      ),
    );

    final gradientDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFDB813),
          Color(0xFFFFE29D),
          Color(0xFFFFC107),
          Color(0xFFFFF5D1),
          Color(0xFFD4AF37),
        ],
      ),
    );

    return OutlinedButton(
      onPressed: () {
        nav.goto(GameRoutePath.level(widget.world, index));
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        side: const BorderSide(color: Colors.teal),
      ),
      child: Ink(
        decoration: levelState.isWon ? gradientDecoration : partialGradientDecoration,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '$index',
            textScaleFactor: textScaleFactor,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
