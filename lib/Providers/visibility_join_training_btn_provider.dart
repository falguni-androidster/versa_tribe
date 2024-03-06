import 'package:flutter/cupertino.dart';
import '../Model/project_list_by_org_id.dart';

class VisibilityJoinTrainingBtnProvider with ChangeNotifier{
  bool _trainingBtnVisibility = false;
  bool get trainingBtnVisibility=>_trainingBtnVisibility;

  setTrainingBtnVisibility(val){
    _trainingBtnVisibility = val;
    notifyListeners();
  }
}


class VisibilityProvider with ChangeNotifier {
  bool _projectJoinBtnVisibility = true;
  bool get projectJoinBtnVisibility=>_projectJoinBtnVisibility;
  bool _projectCancelBtnVisibility = true;
  bool get projectCancelBtnVisibility=>_projectCancelBtnVisibility;

  setProjectBtnVisibility({join,cancel}){
    _projectJoinBtnVisibility = join;
    _projectCancelBtnVisibility = cancel;
    notifyListeners();
  }


  List<ProjectListByOrgIDModel> dataList = [ProjectListByOrgIDModel()];
  void updateIsApproved(int itemId, bool newStatus)
  {
    final itemIndex = dataList.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      dataList[itemIndex].isApproved = newStatus;
      notifyListeners();
    }
  }

}
