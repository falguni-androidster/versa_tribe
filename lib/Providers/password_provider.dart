import 'package:flutter/foundation.dart';

class PwdProvider with ChangeNotifier{
  bool _visible = true;
  bool get visible=>_visible;

  setVisible() {
    _visible = !_visible;
    notifyListeners();
  }
}