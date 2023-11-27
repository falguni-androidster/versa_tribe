import 'package:flutter/cupertino.dart';
import 'package:versa_tribe/Model/approve_organization.dart';
import '../Model/request_organization.dart';
import '../Model/department.dart';
import '../Model/search_organigation.dart';

///tab bar index provider
class IndexProvider with ChangeNotifier{
  int _index=0;
  int get index=>_index;

  setIndex(index){
    _index = index;
    notifyListeners();
  }
}

class DisplayManageOrgProvider with ChangeNotifier{
  final List<RequestOrgModel> _requestOrgDataList =[];
  List<RequestOrgModel> get requestOrgDataList => _requestOrgDataList;
  final List<ApproveOrgModel> _approveOrgDataList =[];
  List<ApproveOrgModel> get approveOrgDataList => _approveOrgDataList;

  setRequestOrgData(requestOrgData){
   requestOrgData.forEach((ob){
      _requestOrgDataList.add(RequestOrgModel.fromJson(ob));
      notifyListeners();
    });
  }
  setApproveOrgData(approveOrgData){
   approveOrgData.forEach((ob){
      _approveOrgDataList.add(ApproveOrgModel.fromJson(ob));
      notifyListeners();
    });
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