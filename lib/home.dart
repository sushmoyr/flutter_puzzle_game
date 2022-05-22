import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_game/image_splitter.dart';
import 'package:flutter_puzzle_game/puzzle_notifier.dart';
import 'package:image_picker/image_picker.dart';

import 'puzzle_cell.dart';
import 'tuple.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PuzzleNotifier notifier = PuzzleNotifier();

  @override
  void initState() {
    super.initState();
    notifier.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    notifier.onGameFinished = (moves) {
      print('G A M E F I N I S H E D !!!');
    };
  }

  Uint8List? image;

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                'Puzzle Time...',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: LayoutBuilder(builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              double maxHeight = constraints.maxHeight;

              double dimension = min(maxWidth, maxHeight);
              dimension = dimension - dimension % 9;

              switch (notifier.state) {
                case GameState.idle:
                  return Container();
                case GameState.loading:
                  return PuzzleWidget(
                    dimension: dimension,
                    notifier: notifier,
                  );
                case GameState.running:
                  return PuzzleWidget(
                    dimension: dimension,
                    notifier: notifier,
                  );
                case GameState.finished:
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'G A M E',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          'F I N I S H E D',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: 24),
                        Text(
                          notifier.moves.toString(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  );
              }
            }),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: (notifier.state == GameState.idle)
                  ? ElevatedButton(
                      child: Text('Start Game'),
                      onPressed: () {
                        notifier.start(shuffle: 4);
                      },
                    )
                  : (notifier.state == GameState.loading)
                      ? Text('Starting Game...!!!')
                      : (notifier.state == GameState.running)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Moves: ${notifier.moves}'),
                                OutlinedButton(
                                  onPressed: notifier.stopGame,
                                  child: Text('Stop Game'),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              child: Text('Reset'),
                              onPressed: () {
                                notifier.reset();
                              },
                            ),
            ),
          )
        ],
      ),
    );
  }
}

class PuzzleWidget extends StatefulWidget {
  const PuzzleWidget(
      {Key? key, required this.dimension, required this.notifier})
      : super(key: key);

  final double dimension;
  final PuzzleNotifier notifier;

  @override
  State<PuzzleWidget> createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  late PuzzleNotifier puzzleNotifier;

  @override
  initState() {
    super.initState();

    puzzleNotifier = widget.notifier;
    puzzleNotifier.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    // board = createRandomBoard();
    // cells = [];
    // createPuzzleCellData(board);
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = (widget.dimension / 3).floorToDouble();

    //print('Total area: ${widget.size}');
    //print('cell size: $cellSize');

    //print(board);

    //for (PuzzleCell value in puzzleNotifier.cells) {
    //print(value.toString());
    //}

    return Center(
      child: SizedBox.square(
        dimension: widget.dimension,
        child: Stack(
          children: [
            for (var cell in puzzleNotifier.cells)
              GestureDetector(
                onTap: () {
                  // print('Tapped: ${cell.dx}, ${cell.dy}');
                  puzzleNotifier.moveTile(cell.dx, cell.dy);
                },
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                  onEnd: () {
                    puzzleNotifier.checkFinish();
                  },
                  alignment: cell.alignment,
                  child: Container(
                    width: cellSize,
                    height: cellSize,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4.0),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // decoration: BoxDecoration(
                    //   color: cell.color,
                    //   image: DecorationImage(
                    //     image: MemoryImage(
                    //       Uint8List.fromList(cell.image),
                    //     ),
                    //   ),
                    // ),
                    child: cell.image,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
