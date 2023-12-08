import 'package:flutter/material.dart';

class CallSwitchProvider with ChangeNotifier{
  bool visibleCall = true;
  bool get _visibleCall => visibleCall;

  setVisible() {
    visibleCall = !_visibleCall;
    notifyListeners();
  }
}