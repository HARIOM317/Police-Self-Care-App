import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<String> textList = [
    'Latest Information 1',
    'Latest Information 2',
    'Latest Information 3',
    'Latest Information 4',
  ];
}
