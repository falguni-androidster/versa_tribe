import 'package:flutter/cupertino.dart';

class DropMenuProvider with ChangeNotifier{
  ///Take Training Dropdown
  int _dropMenu = 0;
  int get dropMenu => _dropMenu;
  setDropMenuVisibility(val){
    _dropMenu=val;
    notifyListeners();
  }

  String _tpMenuItems = "All";
  String get tpMenuItems=>_tpMenuItems;
  setDropMenu(menu){
    _tpMenuItems=menu;
  }


  ///Give Training Dropdown
  int _giveDropMenu = 0;
  int get giveDropMenu => _giveDropMenu;
  setGiveDropMenuVisibility(val){
    _giveDropMenu=val;
    notifyListeners();
  }

  String _giveTrainingMenuItems = "Pending Request";
  String get giveTrainingMenuItems=>_giveTrainingMenuItems;
  setGiveTDropMenu(menu){
    _giveTrainingMenuItems=menu;
  }



  ///Give Training Dropdown
  int _orgTrainDropMenu = 0;
  int get orgTrainDropMenu => _orgTrainDropMenu;
  setOrgTrainDropMenuVisibility(val){
    _orgTrainDropMenu=val;
    notifyListeners();
  }

  String _orgTrainTrainingMenuItems = "Pending Request";
  String get orgTrainTrainingMenuItems=>_orgTrainTrainingMenuItems;
  setOrgTrainTDropMenu(menu){
    _orgTrainTrainingMenuItems=menu;
  }


  ///OrgAdmin Project
  int _orgProjectDropMenu = 0;
  int get orgProjectDropMenu => _orgProjectDropMenu;
  setOrgProjectDropMenuVisibility(val){
    _orgProjectDropMenu=val;
    notifyListeners();
  }

  String _orgProjectMenuItems = "Pending Request";
  String get orgProjectMenuItems=>_orgProjectMenuItems;
  setOrgProjectTDropMenu(menu){
    _orgProjectMenuItems=menu;
  }
  ///For all Dropdown menu notify
  notify(){
    print("----NoTiFy------");
    notifyListeners();
  }
}
