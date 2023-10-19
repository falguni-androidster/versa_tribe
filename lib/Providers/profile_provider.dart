import 'package:flutter/cupertino.dart';

import '../Utils/custom_string.dart';

class ProfileProvider with ChangeNotifier{
  String _selectedValue = CustomString.male;
  String get selectedValue =>_selectedValue;

  setGenderValue(gender){
    _selectedValue = gender;
    notifyListeners();
  }
}