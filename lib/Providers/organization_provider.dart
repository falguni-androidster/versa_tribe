import 'package:flutter/material.dart';

class OrganizationProvider with ChangeNotifier{
  String? _switchOrganization;
  String? get switchOrganization => _switchOrganization;
  int? _switchOrgId;
  int? get switchOrgId => _switchOrgId;
  bool? _isAdmin;
  bool? get isAdmin => _isAdmin;

  setSwitchOrganization(organization,orgID,orgAdmin) {
    _switchOrganization = organization;
    _switchOrgId=orgID;
    _isAdmin=orgAdmin;
    notifyListeners();
  }


  bool _visible = false;
  bool get visible=>_visible;
  setVisible(value){
    _visible=value;
    notifyListeners();
  }

  notify(){
    notifyListeners();
  }
}
