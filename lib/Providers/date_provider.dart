import 'package:flutter/cupertino.dart';

class DateProvider with ChangeNotifier{
  String _startDateInput = "";
  String _endDateInput = "";
  String get startDateInput => _startDateInput;
  String get endDateInput => _endDateInput;

  DateTime _pickedDate = DateTime.now();
  DateTime get pickedDate => _pickedDate;

  setStartDate(date, pickedDate){
    _startDateInput = date;
    _pickedDate = pickedDate;
    notifyListeners();
  }
  setEndDate(date){
    _endDateInput = date;
    notifyListeners();
  }
}

class YOPDateProvider with ChangeNotifier{
  String _yopDateInput = "";
  String get yopDateInput => _yopDateInput;

  setYopDate(date){
    _yopDateInput = date;
    notifyListeners();
  }
}

class DobProvider with ChangeNotifier{
  String _dobInput = '';
  String get dobInput => _dobInput;

  setDobDate(date){
    _dobInput = date;
    notifyListeners();
  }

}

class TrainingDobProvider with ChangeNotifier{
  String _trainingStartDateInput = "";
  String _trainingEndDateInput = "";
  String get trainingStartDateInput => _trainingStartDateInput;
  String get trainingEndDateInput => _trainingEndDateInput;

  DateTime _trainingPickedDate = DateTime.now();
  DateTime get pickedDate => _trainingPickedDate;

  setTrainingStartDate(date, pickedDate){
    _trainingStartDateInput = date;
    _trainingPickedDate = pickedDate;
    notifyListeners();
  }
  setTrainingEndDate(date){
    _trainingEndDateInput = date;
    notifyListeners();
  }

}