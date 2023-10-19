import 'package:flutter/cupertino.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';

class ManageBottomTabProvider with ChangeNotifier{
  Widget _currentScreen = const DashboardScreen(); // Our first view in viewport
  Widget get currentScreen =>_currentScreen;
  int _currentTab = 0; // to keep track of active tab index
  int get currentTab => _currentTab;

  manageBottomTab(Widget currentScreen, int currentTab){
    _currentScreen = currentScreen;
    _currentTab = currentTab;
    notifyListeners();
  }
}