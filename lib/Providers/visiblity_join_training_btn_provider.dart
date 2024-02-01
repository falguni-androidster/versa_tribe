import 'package:flutter/cupertino.dart';

class VisibilityJoinTrainingBtnProvider with ChangeNotifier{
  bool _trainingBtnVisibility = false;
  bool get trainingBtnVisibility=>_trainingBtnVisibility;

  setTrainingBtnVisibility(val){
    _trainingBtnVisibility = val;
    notifyListeners();
  }
}


class VisibilityJoinProjectBtnProvider with ChangeNotifier{
  bool _projectBtnVisibility = false;
  bool get projectBtnVisibility=>_projectBtnVisibility;

  setProjectBtnVisibility(val){
    _projectBtnVisibility = val;
    notifyListeners();
  }
}
