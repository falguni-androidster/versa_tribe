import 'package:flutter/material.dart';

class OrgProfileBtnVisibility with ChangeNotifier{
  bool _updateVisible = true;
  bool get updateBtnVisible=>_updateVisible;

  setVisibility(value) {
    _updateVisible = value;
    notifyListeners();
  }
}

