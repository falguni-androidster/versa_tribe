import 'package:flutter/material.dart';

class ConfirmPwdProvider with ChangeNotifier{
  bool _visible = true;
  bool get visible=>_visible;

  setVisible() {
    _visible = !_visible;
    notifyListeners();
  }
}

class SignInPwdProvider with ChangeNotifier{
  bool _visible = true;
  bool get visible=>_visible;

  setVisible() {
    _visible = !_visible;
    notifyListeners();
  }
}

class SignUpPwdProvider with ChangeNotifier{
  bool _visible = true;
  bool get visible=>_visible;

  setVisible() {
    _visible = !_visible;
    notifyListeners();
  }
}