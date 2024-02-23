import 'package:flutter/material.dart';
import 'package:versa_tribe/Model/switch_data.dart';

class SwitchProvider with ChangeNotifier{
  SwitchDataModel _switchDataModel=SwitchDataModel();
  SwitchDataModel get switchData => _switchDataModel;
  setSwitchData(SwitchDataModel data){
    _switchDataModel = data;
  }
  notify(){
    notifyListeners();
  }
}

class CallSwitchProvider with ChangeNotifier{
  bool _isSwitched = false;
  bool get Switch => _isSwitched;

  void callSwitch(switchVal) {
    _isSwitched = switchVal;
    notifyListeners();
  }
}

class ButtonVisibilityProvider with ChangeNotifier {
  bool _isButtonVisible = true;
  bool get isButtonVisible => _isButtonVisible;

  void toggleButtonVisibility() {
    _isButtonVisible = !_isButtonVisible;
    notifyListeners();
  }
}
