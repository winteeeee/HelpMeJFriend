import 'package:flutter/cupertino.dart';

class IndexProvider with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(idx) {
    _index = idx;
    notifyListeners();
  }
}