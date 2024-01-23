import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

///tab bar index provider
class IndexProvider with ChangeNotifier{
  int _index=0;
  int get index=>_index;

  setIndex(index){
    _index = index;
    notifyListeners();
  }

///----AdminSide----
  int _orgMemberIndex=0;
  int get orgMemberIndex=>_orgMemberIndex;

  setOrgMemberIndex(index){
    _orgMemberIndex = index;
    notifyListeners();
  }
}

///User side
class RequestManageOrgProvider with ChangeNotifier{
  final List<RequestOrgModel> _requestOrgDataList =[];
  List<RequestOrgModel> get requestOrgDataList => _requestOrgDataList;

  setRequestOrgData(requestOrgData){
   requestOrgData.forEach((ob){
      _requestOrgDataList.add(RequestOrgModel.fromJson(ob));
    });
   notifyListeners();
  }
}
class ApprovedManageOrgProvider with ChangeNotifier{
  final List<ApproveOrgModel> _approveOrgDataList =[];
  List<ApproveOrgModel> get approveOrgDataList => _approveOrgDataList;

  setApproveOrgData(approveOrgData){
    approveOrgData.forEach((ob){
      _approveOrgDataList.add(ApproveOrgModel.fromJson(ob));
    });
    notifyListeners();
  }
}


///Admin side
class RequestMemberProvider with ChangeNotifier{
  final List<PendingRequestMemberModel> _requestPendingOrgDataList =[];
  List<PendingRequestMemberModel> get requestPendingOrgDataList => _requestPendingOrgDataList;

  setPendingRequestOrgData(requestOrgData){
    requestOrgData.forEach((ob){
      _requestPendingOrgDataList.add(PendingRequestMemberModel.fromJson(ob));
      notifyListeners();
    });
  }
  notify(){
    notifyListeners();
  }
}
class ApprovedMemberProvider with ChangeNotifier{
  final List<ApproveMemberModel> _approveOrgDataList =[];
  List<ApproveMemberModel> get approveOrgDataList => _approveOrgDataList;
  setApproveOrgData(approveOrgData){
    approveOrgData.forEach((ob){
      _approveOrgDataList.add(ApproveMemberModel.fromJson(ob));
      notifyListeners();
    });
  }
  notify(){
    notifyListeners();
  }
}

class SearchOrgProvider with ChangeNotifier{
   final List<SearchOrgModel> _orgList =[];
   List<SearchOrgModel> get orgList => _orgList;
   bool _visible = false;
   bool get visible => _visible;

  setSearchedOrg(orgName){
    orgName.forEach((ob){
      _orgList.add(SearchOrgModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchDepartmentProvider with ChangeNotifier{
   final List<DepartmentModel> _departmentList =[];
   List<DepartmentModel> get departmentList => _departmentList;
   bool _visible = false;
   bool get visible => _visible;

  setSearchedDepartment(dpName){
    dpName.forEach((ob){
      _departmentList.add(DepartmentModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}
