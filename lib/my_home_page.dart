import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shortest_path/constants.dart';
import 'package:shortest_path/home_page_viewmodel.dart';
import 'package:shortest_path/locator.dart';
import 'package:shortest_path/testing.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<List<BoardElement>> generateBoardElements(int row, int col) {
    return List.generate(
        row,
        (r) => List.generate(col, (c) {
              return BoardElement(Pair(r, c));
            }));
  }

  List<List<BoardElement>> boardElements =
      generateBoardElements(boardDimentions.first, boardDimentions.second);

  @override
  Widget build(BuildContext context) {
    HomePageViewModel homePageViewModel = context.watch<HomePageViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
          child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Board(
              boardElements: boardElements,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    // log(boardElements[homePageViewModel.start.first]
                    //         [homePageViewModel.start.second]
                    //     .location
                    //     .toString());
                    // List<Pair> n = neighbors(
                    //     boardElements[homePageViewModel.start.first]
                    //         [homePageViewModel.start.second]);
                    Map<Pair, Pair> cameFrom = {};

                    Map<Pair, double> costSoFar = {};
                    for (var rows in boardElements) {
                      for (var element in rows) {
                        costSoFar[element.location] = double.infinity;
                      }
                    }

                    aStar(boardElements, homePageViewModel.start,
                        homePageViewModel.end, cameFrom, costSoFar);
                    log(cameFrom.toString());

                    // final queue = PriorityQueue<Pair>(
                    //     (a, b) => a.first.compareTo(b.first));
                    // queue.add(Pair(3, 0));
                    // queue.add(Pair(1, 1));
                    // queue.add(Pair(0, 0));
                    // while (queue.isNotEmpty) {
                    //   // log("in_while");
                    //   log(queue.removeFirst().toString());
                    // }

                    // log(queue.removeFirst().toString());

                    // int i = homePageViewModel.start.second + 1;
                    // Timer.periodic(Duration(milliseconds: 300), (timer) {
                    //   if (i < homePageViewModel.end.second) {
                    //     log(i.toString());
                    //     boardElements[homePageViewModel.start.first][i]
                    //         .changeState(ElementState.path);
                    //     i++;
                    //   }
                    // });
                    // for (int i = homePageViewModel.start.second + 1;
                    //     i < homePageViewModel.end.second;
                    //     i++) {
                    //   log(i.toString());
                    //   boardElements[homePageViewModel.start.first][i]
                    //       .changeState(ElementState.path);
                    // }
                  },
                  color: Colors.white,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.cyan,
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    homePageViewModel.changeElementState(ElementState.empty);
                  },
                  color: Colors.white,
                  child: Icon(
                    Icons.stop,
                    color: Colors.red.shade400,
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    homePageViewModel.changeElementState(ElementState.start);
                  },
                  color: startColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    homePageViewModel.changeElementState(ElementState.end);
                  },
                  color: endColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    homePageViewModel.stop = true;

                    homePageViewModel.changeElementState(ElementState.empty);
                  },
                  color: emptyColor,
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey.shade300,
                  ),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
                MaterialButton(
                  height: 50,
                  onPressed: () {
                    homePageViewModel.changeElementState(ElementState.block);
                  },
                  color: blockColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(2),
                  shape: CircleBorder(
                      side: BorderSide(width: 5, color: Colors.white)),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}

class Board extends StatelessWidget {
  final List<List<BoardElement>> boardElements;
  const Board({Key? key, required this.boardElements}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        color: Colors.cyan.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                  boardDimentions.first,
                  (r) => Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(boardDimentions.second, (c) {
                            return BoardElementWidget(
                              address: Pair(r, c),
                              boardElement: boardElements[r][c],
                              // gameCallback: connectFourViewModel.game,
                            );
                          }),
                        ),
                      )),
            )),
      ),
    );
  }
}

class BoardElementWidget extends StatefulWidget {
  BoardElement boardElement;
  Pair address;

  BoardElementWidget(
      {required this.address, required this.boardElement, Key? key})
      : super(key: key);

  @override
  State<BoardElementWidget> createState() => _BoardElementWidgetState();
}

class _BoardElementWidgetState extends State<BoardElementWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(1.5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              widget.boardElement.changeState(
                  getIt<HomePageViewModel>().elementState,
                  address: widget.address);
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: widget.boardElement.color,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        ),
      ),
    );
  }
}

enum ElementState { empty, start, end, block, path }

class BoardElement {
  BoardElement(this.location);
  Pair location;
  ElementState state = ElementState.empty;
  Color _color = Colors.white;
  Color get color => _color;
  changeState(ElementState boardState, {Pair? address}) {
    switch (boardState) {
      case (ElementState.block):
        _color = blockColor;
        break;
      case (ElementState.empty):
        _color = emptyColor;
        break;
      case (ElementState.start):
        getIt<HomePageViewModel>().setStart(address!);
        _color = startColor;
        break;
      case (ElementState.end):
        getIt<HomePageViewModel>().setEnd(address!);

        _color = endColor;
        break;
      case (ElementState.path):
        _color = pathColor;
        break;
    }
    getIt<HomePageViewModel>().changeState();
  }
}
