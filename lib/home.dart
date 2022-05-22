import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_puzzle_game/puzzle_notifier.dart';

import 'puzzle_cell.dart';

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
      setState(() {});
    });

    notifier.onGameFinished = (moves) {
      print('G A M E F I N I S H E D !!!');
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
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

              switch (notifier.state) {
                case GameState.idle:
                  return Container();
                case GameState.loading:
                  return PuzzleWidget(
                    size: Size.square(dimension),
                    notifier: notifier,
                  );
                case GameState.running:
                  return PuzzleWidget(
                    size: Size.square(dimension),
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

              return (notifier.state == GameState.idle)
                  ? Container()
                  : PuzzleWidget(
                      size: Size.square(dimension),
                      notifier: notifier,
                    );
            }),
          ),
          Expanded(
            flex: 4,
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
                          ? Text('Moves: ${notifier.moves}')
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
  const PuzzleWidget({Key? key, required this.size, required this.notifier})
      : super(key: key);

  final Size size;
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
      setState(() {});
    });

    // board = createRandomBoard();
    // cells = [];
    // createPuzzleCellData(board);
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    double cellSize = (widget.size.width / 3).floorToDouble();

    //print('Total area: ${widget.size}');
    //print('cell size: $cellSize');

    //print(board);

    //for (PuzzleCell value in puzzleNotifier.cells) {
    //print(value.toString());
    //}

    return SizedBox.fromSize(
      size: widget.size,
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
                  color: cell.color,
                  alignment: Alignment.center,
                  child: Text(
                    cell.value.toString(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
