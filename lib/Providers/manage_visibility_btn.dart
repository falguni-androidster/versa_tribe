import 'package:flutter/material.dart';

class OrgProfileBtnVisibility with ChangeNotifier{
  bool _updateVisible = true;
  bool get updateBtnVisible=>_updateVisible;

  setVisibility(value) {
    _updateVisible = value;
    notifyListeners();
  }
}



class CirculerIndicationProvider with ChangeNotifier{
  bool _loading = true;
  bool get loading=>_loading;
  setLoading(value) {
    _loading = value;
    notifyListeners();
  }
}
