class SearchDepartmentModel {
  int? deptId;
  String? deptName;
  int? parentDeptId;
  String? parentDeptName;

  SearchDepartmentModel(
      {this.deptId, this.deptName, this.parentDeptId, this.parentDeptName});

  SearchDepartmentModel.fromJson(Map<String, dynamic> json) {
    deptId = json['Dept_Id'];
    deptName = json['Dept_Name'];
    parentDeptId = json['Parent_dept_Id'];
    parentDeptName = json['Parent_dept_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Dept_Id'] = this.deptId;
    data['Dept_Name'] = this.deptName;
    data['Parent_dept_Id'] = this.parentDeptId;
    data['Parent_dept_Name'] = this.parentDeptName;
    return data;
  }
}