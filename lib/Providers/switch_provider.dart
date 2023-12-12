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
  bool visibleCall = true;
  bool get _visibleCall => visibleCall;

  setVisible() {
    visibleCall = !_visibleCall;
    notifyListeners();
  }
}