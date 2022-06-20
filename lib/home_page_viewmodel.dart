import 'package:flutter/material.dart';
import 'package:shortest_path/my_home_page.dart';

class HomePageViewModel with ChangeNotifier {
  bool stop = false;
  late Pair _start;
  late Pair _end;

  Pair get start => _start;
  Pair get end => _end;

  setStart(Pair address) => _start = address;
  setEnd(Pair end) => _end = end;

  ElementState _elementState = ElementState.empty;
  ElementState get elementState => _elementState;
  changeElementState(ElementState elementState) {
    _elementState = elementState;
    notifyListeners();
  }

  void changeState() {
    notifyListeners();
  }
}

class Pair<T> {
  final T first;
  final T second;

  const Pair(this.first, this.second);
  @override
  String toString() {
    return "{$first,$second}";
  }
   @override
  int get hashCode => (first.hashCode * 37 + second.hashCode * 17) & 0x3FFFFFFF;
  @override
  bool operator==(Object other) => 
      other is Pair && first == other.first && second == other.second;
}
