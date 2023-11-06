import 'package:flutter/cupertino.dart';

class OrganizationProvider with ChangeNotifier{
  String? _switchOrganization;
  String? get switchOrganization => _switchOrganization;

  setSwitchOrganization(organization) {
    _switchOrganization = organization;
    notifyListeners();
  }


  bool _visible = false;
  bool get visible=>_visible;
  setVisible(value){
    print("Visiblity====>$value");
    _visible=value;
    notifyListeners();
  }

  notify(){
    notifyListeners();
  }
}