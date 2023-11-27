class RequestOrgModel {
  int? personId;
  String? firstName;
  String? lastName;
  String? personTOwner;
  int? orgId;
  String? orgName;
  int? deptId;
  String? deptName;
  int? requestStatus;
  String? requestStatusName;
  String? deptReq;
  String? tStamp;
  String? tOwner;

  RequestOrgModel(
      {this.personId,
        this.firstName,
        this.lastName,
        this.personTOwner,
        this.orgId,
        this.orgName,
        this.deptId,
        this.deptName,
        this.requestStatus,
        this.requestStatusName,
        this.deptReq,
        this.tStamp,
        this.tOwner});

  RequestOrgModel.fromJson(Map<String, dynamic> json) {
    personId = json['Person_Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    personTOwner = json['Person_TOwner'];
    orgId = json['Org_Id'];
    orgName = json['Org_Name'];
    deptId = json['Dept_Id'];
    deptName = json['Dept_Name'];
    requestStatus = json['Request_Status'];
    requestStatusName = json['Request_Status_Name'];
    deptReq = json['Dept_Req'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Person_Id'] = personId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Person_TOwner'] = personTOwner;
    data['Org_Id'] = orgId;
    data['Org_Name'] = orgName;
    data['Dept_Id'] = deptId;
    data['Dept_Name'] = deptName;
    data['Request_Status'] = requestStatus;
    data['Request_Status_Name'] = requestStatusName;
    data['Dept_Req'] = deptReq;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    return data;
  }
}