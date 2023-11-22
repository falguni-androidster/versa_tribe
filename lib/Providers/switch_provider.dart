import 'package:flutter/cupertino.dart';
import 'package:versa_tribe/Model/SwitchDataModel.dart';

class SwitchProvider with ChangeNotifier{
  SwitchDataModel _switchDataModel=SwitchDataModel();
  SwitchDataModel get switchData => _switchDataModel;
  setSwitchData(SwitchDataModel data){
    _switchDataModel = data;
  }
  notify(){notifyListeners();}
}