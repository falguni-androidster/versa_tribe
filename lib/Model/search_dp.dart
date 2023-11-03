/// Dept_Id : 1089
/// Dept_Name : "Admin"
/// Parent_dept_Id : 1090
/// Parent_dept_Name : "CA"

class SearchDpModel {
  SearchDpModel({
      int? deptId, 
      String? deptName, 
      int? parentDeptId, 
      String? parentDeptName,}){
    _deptId = deptId;
    _deptName = deptName;
    _parentDeptId = parentDeptId;
    _parentDeptName = parentDeptName;
}

  SearchDpModel.fromJson(dynamic json) {
    _deptId = json['Dept_Id'];
    _deptName = json['Dept_Name'];
    _parentDeptId = json['Parent_dept_Id'];
    _parentDeptName = json['Parent_dept_Name'];
  }
  int? _deptId;
  String? _deptName;
  int? _parentDeptId;
  String? _parentDeptName;
SearchDpModel copyWith({  int? deptId,
  String? deptName,
  int? parentDeptId,
  String? parentDeptName,
}) => SearchDpModel(  deptId: deptId ?? _deptId,
  deptName: deptName ?? _deptName,
  parentDeptId: parentDeptId ?? _parentDeptId,
  parentDeptName: parentDeptName ?? _parentDeptName,
);
  int? get deptId => _deptId;
  String? get deptName => _deptName;
  int? get parentDeptId => _parentDeptId;
  String? get parentDeptName => _parentDeptName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Dept_Id'] = _deptId;
    map['Dept_Name'] = _deptName;
    map['Parent_dept_Id'] = _parentDeptId;
    map['Parent_dept_Name'] = _parentDeptName;
    return map;
  }

}