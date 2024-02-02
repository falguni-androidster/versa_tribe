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
  bool _projectJoinBtnVisibility = true;
  bool get projectJoinBtnVisibility=>_projectJoinBtnVisibility;
  bool _projectCancelBtnVisibility = true;
  bool get projectCancelBtnVisibility=>_projectCancelBtnVisibility;

  setProjectBtnVisibility({join,cancel}){
    _projectJoinBtnVisibility = join;
    _projectCancelBtnVisibility = cancel;
    notifyListeners();
  }
}
