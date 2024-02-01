import 'package:flutter/cupertino.dart';

class VisibilityJoinTrainingBtnProvider with ChangeNotifier{
  bool _trainingBtnVisibility = false;
  bool get trainingBtnVisibility=>_trainingBtnVisibility;

  setTrainingBtnVisibility(val){
    _trainingBtnVisibility = val;
    notifyListeners();
  }
}
