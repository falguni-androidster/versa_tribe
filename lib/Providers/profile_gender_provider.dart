import 'package:flutter/cupertino.dart';

class ProfileGenderProvider with ChangeNotifier{
  String _selectedValue = 'Male';
  String get selectedValue => _selectedValue;

  setGenderValue(gender){
    _selectedValue = gender;
    notifyListeners();
  }
}


class RadioComIndProvider with ChangeNotifier{
  String _selectedValue = "";
  String get selectedValue => _selectedValue;

  setRadioValue(radioVal){
    _selectedValue = radioVal;
  }
  callNotify(){
    notifyListeners();
  }
}

class AddRadioComIndProvider with ChangeNotifier{
  String _selectedValue = "Company";
  String get selectedValue => _selectedValue;

  setRadioValue(radioVal){
    _selectedValue = radioVal;
  }
  callRadioNotify(){
    notifyListeners();
  }
}