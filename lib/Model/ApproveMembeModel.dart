/// Person_Id : 4
/// FirstName : "Shubham"
/// LastName : "Shukla"
/// Person_TOwner : "sbmshukla17@gmail.com"
/// Org_Id : 5
/// Org_Name : "Ksq_FlutterTech"
/// Dept_Id : 93
/// Dept_Name : "Kotlin"
/// Request_Status : 0
/// Request_Status_Name : "REQUESTED"
/// Dept_Req : null
/// TStamp : "2023-12-05T05:34:06.5850185"
/// TOwner : "sbmshukla17@gmail.com"

class ApproveMemberModel {
  ApproveMemberModel({
      int? personId, 
      String? firstName, 
      String? lastName, 
      String? personTOwner, 
      int? orgId, 
      String? orgName, 
      int? deptId, 
      String? deptName, 
      int? requestStatus, 
      String? requestStatusName, 
      dynamic deptReq, 
      String? tStamp, 
      String? tOwner,}){
    _personId = personId;
    _firstName = firstName;
    _lastName = lastName;
    _personTOwner = personTOwner;
    _orgId = orgId;
    _orgName = orgName;
    _deptId = deptId;
    _deptName = deptName;
    _requestStatus = requestStatus;
    _requestStatusName = requestStatusName;
    _deptReq = deptReq;
    _tStamp = tStamp;
    _tOwner = tOwner;
}

  ApproveMemberModel.fromJson(dynamic json) {
    _personId = json['Person_Id'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
    _personTOwner = json['Person_TOwner'];
    _orgId = json['Org_Id'];
    _orgName = json['Org_Name'];
    _deptId = json['Dept_Id'];
    _deptName = json['Dept_Name'];
    _requestStatus = json['Request_Status'];
    _requestStatusName = json['Request_Status_Name'];
    _deptReq = json['Dept_Req'];
    _tStamp = json['TStamp'];
    _tOwner = json['TOwner'];
  }
  int? _personId;
  String? _firstName;
  String? _lastName;
  String? _personTOwner;
  int? _orgId;
  String? _orgName;
  int? _deptId;
  String? _deptName;
  int? _requestStatus;
  String? _requestStatusName;
  dynamic _deptReq;
  String? _tStamp;
  String? _tOwner;
ApproveMemberModel copyWith({  int? personId,
  String? firstName,
  String? lastName,
  String? personTOwner,
  int? orgId,
  String? orgName,
  int? deptId,
  String? deptName,
  int? requestStatus,
  String? requestStatusName,
  dynamic deptReq,
  String? tStamp,
  String? tOwner,
}) => ApproveMemberModel(  personId: personId ?? _personId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  personTOwner: personTOwner ?? _personTOwner,
  orgId: orgId ?? _orgId,
  orgName: orgName ?? _orgName,
  deptId: deptId ?? _deptId,
  deptName: deptName ?? _deptName,
  requestStatus: requestStatus ?? _requestStatus,
  requestStatusName: requestStatusName ?? _requestStatusName,
  deptReq: deptReq ?? _deptReq,
  tStamp: tStamp ?? _tStamp,
  tOwner: tOwner ?? _tOwner,
);
  int? get personId => _personId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get personTOwner => _personTOwner;
  int? get orgId => _orgId;
  String? get orgName => _orgName;
  int? get deptId => _deptId;
  String? get deptName => _deptName;
  int? get requestStatus => _requestStatus;
  String? get requestStatusName => _requestStatusName;
  dynamic get deptReq => _deptReq;
  String? get tStamp => _tStamp;
  String? get tOwner => _tOwner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Person_Id'] = _personId;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    map['Person_TOwner'] = _personTOwner;
    map['Org_Id'] = _orgId;
    map['Org_Name'] = _orgName;
    map['Dept_Id'] = _deptId;
    map['Dept_Name'] = _deptName;
    map['Request_Status'] = _requestStatus;
    map['Request_Status_Name'] = _requestStatusName;
    map['Dept_Req'] = _deptReq;
    map['TStamp'] = _tStamp;
    map['TOwner'] = _tOwner;
    return map;
  }

}