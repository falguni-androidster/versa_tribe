import 'package:flutter/cupertino.dart';
import '../Model/manage_organization.dart';

///tab bar index provider
class IndexProvider with ChangeNotifier{
  int _index=0;
  int get index=>_index;

  setIndex(index){
    _index = index;
    notifyListeners();
  }
}

class DisplayManageOrgProvider with ChangeNotifier{
  final List<ManageOrgModel> _manageOrgDataList =[];
  List<ManageOrgModel> get manageOrgDataList => _manageOrgDataList;

  setManageOrgData(manageOrgData){
    manageOrgData.forEach((ob){
      _manageOrgDataList.add(ManageOrgModel.fromJson(ob));
      notifyListeners();
    });
  }
}