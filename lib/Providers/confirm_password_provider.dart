import 'package:flutter/foundation.dart';

class ConfirmPwdProvider with ChangeNotifier{
  bool _visible = true;
  bool get visible=>_visible;

  setVisible() {
    _visible = !_visible;
    notifyListeners();
  }
}