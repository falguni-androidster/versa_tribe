import 'package:flutter/cupertino.dart';

class OrganizationProvider with ChangeNotifier{
  String _switchOrganization = "ParaFox";
  String get switchOrganization => _switchOrganization;

  setSwitchOrganization(organization) {
    _switchOrganization = organization;
    notifyListeners();
  }
}