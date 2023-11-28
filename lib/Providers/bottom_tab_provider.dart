import 'package:flutter/cupertino.dart';

class ManageBottomTabProvider with ChangeNotifier{
  int _currentTab = 0; // to keep track of active tab index
  int get currentTab => _currentTab;

  manageBottomTab(int currentTab){
    _currentTab = currentTab;
    notifyListeners();
  }
}