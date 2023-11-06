import 'package:flutter/foundation.dart';

class JoinBtnDropdownBtnProvider with ChangeNotifier{
  List<String> _string =[];
  List<String> get string=>_string;

  setString(stringData) {
    _string = stringData;
    notifyListeners();
  }
}