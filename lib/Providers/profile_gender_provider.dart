import 'package:flutter/cupertino.dart';

class ProfileGenderProvider with ChangeNotifier{
  String _selectedValue = 'Male';
  String get selectedValue => _selectedValue;

  setGenderValue(gender){
    _selectedValue = gender;
    notifyListeners();
  }
}