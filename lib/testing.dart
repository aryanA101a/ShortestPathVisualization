import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:shortest_path/constants.dart';
import 'package:shortest_path/home_page_viewmodel.dart';
import 'package:shortest_path/locator.dart';
import 'package:shortest_path/my_home_page.dart';

reconstructPath(Map cameFrom, current) {
  var totalPath = {current};
  var cameFromKeys = cameFrom.keys;
  // while (cameFromKeys.contains(current)) {
  //   current = cameFrom[current];
  //   totalPath.add(current);
  // }
  return totalPath;
}

//{{5,6}: {5,6}, {6,6}: {5,6}, {5,7}: {5,6}, {4,6}: {5,6}, {5,5}: {5,6}, {6,7}: {5,7}, {5,8}: {5,7}, {4,7}: {5,7}, {6,8}: {5,8}, {5,9}: {5,8}, {4,8}: {5,8}, {6,9}: {5,9}, {5,10}: {5,9}, {4,9}: {5,9}}

heuristic(Pair a, Pair b) {
  //  std::abs(a.x - b.x) + std::abs(a.y - b.y);
  return (a.first - b.first).abs() + (a.second - b.second).abs();
}

List<Pair> neighbors(BoardElement node) {
  var dirs = [
    [1, 0],
    [0, 1],
    [-1, 0],
    [0, -1]
  ];
  List<Pair> result = [];
  //12 20
  for (var dir in dirs) {
    var neighbor =
        Pair(node.location.first + dir[0], node.location.second + dir[1]);

    if ((0 <= neighbor.first && neighbor.first < boardDimentions.first) &&
            (0 <= neighbor.second && neighbor.second < boardDimentions.second)
        //  &&(node.color != blockColor)
        ) {
      result.add(neighbor);
    }
  }
  return result;
}

void aStar(List<List<BoardElement>> boardElements, Pair start, Pair goal,
    Map<Pair, Pair> cameFrom, Map<Pair, double> costSoFar) {
  PriorityQueue<Pair> frontier =
      PriorityQueue<Pair>((a, b) => a.second.compareTo(b.second));

  frontier.add(Pair(start, 0));

  cameFrom[start] = start;

  costSoFar[start] = 0;
  log(start.toString());
  log(costSoFar.toString());
  while (frontier.isNotEmpty) {
    log("in_while");
    if (getIt<HomePageViewModel>().stop) {
      break;
    }
    Pair current = frontier.removeFirst().first;
    if (current == goal) {
      log(reconstructPath(cameFrom, current).toString());
      break;
    }
    var neighbours = neighbors(boardElements[current.first][current.second]);
    for (Pair neighbour in neighbours) {
      double newCost = costSoFar[current]! + 1;
      // log(costSoFar[neighbour]!.toString());

      if (newCost < costSoFar[neighbour]!) {
        if (current == neighbour) {
          log("cameFrom:${cameFrom.toString()}");
          break;
        }
        cameFrom[neighbour] = current;
        costSoFar[neighbour] = newCost;
        double priority = newCost + heuristic(neighbour, goal);
        frontier.add(Pair(neighbour, priority));
      }
    }
  }
}
