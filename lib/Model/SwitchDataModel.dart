/// profile : {"Person_Id":141,"FirstName":"Karan","LastName":"Dataniya","TOwner":"Parafox14@gmail.com"}
/// OrgAdmin : [{"Org_Name":"PARAFOX","Org_Id":16}]
/// OrgPerson : [{"Org_Name":"PARAFOX","Org_Id":16}]
/// OrgAdminPersonList : [{"Org_Name":"PARAFOX","Org_Id":16,"IsAdmin":true},{"Org_Name":"PARAFOX","Org_Id":16,"IsAdmin":true}]

class SwitchDataModel {
  SwitchDataModel({
      Profile? profile, 
      List<OrgAdmin>? orgAdmin, 
      List<OrgPerson>? orgPerson, 
      List<OrgAdminPersonList>? orgAdminPersonList,}){
    _profile = profile;
    _orgAdmin = orgAdmin;
    _orgPerson = orgPerson;
    _orgAdminPersonList = orgAdminPersonList;
}

  SwitchDataModel.fromJson(dynamic json) {
    _profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    if (json['OrgAdmin'] != null) {
      _orgAdmin = [];
      json['OrgAdmin'].forEach((v) {
        _orgAdmin?.add(OrgAdmin.fromJson(v));
      });
    }
    if (json['OrgPerson'] != null) {
      _orgPerson = [];
      json['OrgPerson'].forEach((v) {
        _orgPerson?.add(OrgPerson.fromJson(v));
      });
    }
    if (json['OrgAdminPersonList'] != null) {
      _orgAdminPersonList = [];
      json['OrgAdminPersonList'].forEach((v) {
        _orgAdminPersonList?.add(OrgAdminPersonList.fromJson(v));
      });
    }
  }
  Profile? _profile;
  List<OrgAdmin>? _orgAdmin;
  List<OrgPerson>? _orgPerson;
  List<OrgAdminPersonList>? _orgAdminPersonList;
SwitchDataModel copyWith({  Profile? profile,
  List<OrgAdmin>? orgAdmin,
  List<OrgPerson>? orgPerson,
  List<OrgAdminPersonList>? orgAdminPersonList,
}) => SwitchDataModel(  profile: profile ?? _profile,
  orgAdmin: orgAdmin ?? _orgAdmin,
  orgPerson: orgPerson ?? _orgPerson,
  orgAdminPersonList: orgAdminPersonList ?? _orgAdminPersonList,
);
  Profile? get profile => _profile;
  List<OrgAdmin>? get orgAdmin => _orgAdmin;
  List<OrgPerson>? get orgPerson => _orgPerson;
  List<OrgAdminPersonList>? get orgAdminPersonList => _orgAdminPersonList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_profile != null) {
      map['profile'] = _profile?.toJson();
    }
    if (_orgAdmin != null) {
      map['OrgAdmin'] = _orgAdmin?.map((v) => v.toJson()).toList();
    }
    if (_orgPerson != null) {
      map['OrgPerson'] = _orgPerson?.map((v) => v.toJson()).toList();
    }
    if (_orgAdminPersonList != null) {
      map['OrgAdminPersonList'] = _orgAdminPersonList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// Org_Name : "PARAFOX"
/// Org_Id : 16
/// IsAdmin : true

class OrgAdminPersonList {
  OrgAdminPersonList({
      String? orgName, 
      int? orgId, 
      bool? isAdmin,}){
    _orgName = orgName;
    _orgId = orgId;
    _isAdmin = isAdmin;
}

  OrgAdminPersonList.fromJson(dynamic json) {
    _orgName = json['Org_Name'];
    _orgId = json['Org_Id'];
    _isAdmin = json['IsAdmin'];
  }
  String? _orgName;
  int? _orgId;
  bool? _isAdmin;
OrgAdminPersonList copyWith({  String? orgName,
  int? orgId,
  bool? isAdmin,
}) => OrgAdminPersonList(  orgName: orgName ?? _orgName,
  orgId: orgId ?? _orgId,
  isAdmin: isAdmin ?? _isAdmin,
);
  String? get orgName => _orgName;
  int? get orgId => _orgId;
  bool? get isAdmin => _isAdmin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Org_Name'] = _orgName;
    map['Org_Id'] = _orgId;
    map['IsAdmin'] = _isAdmin;
    return map;
  }

}

/// Org_Name : "PARAFOX"
/// Org_Id : 16

class OrgPerson {
  OrgPerson({
      String? orgName, 
      int? orgId,}){
    _orgName = orgName;
    _orgId = orgId;
}

  OrgPerson.fromJson(dynamic json) {
    _orgName = json['Org_Name'];
    _orgId = json['Org_Id'];
  }
  String? _orgName;
  int? _orgId;
OrgPerson copyWith({  String? orgName,
  int? orgId,
}) => OrgPerson(  orgName: orgName ?? _orgName,
  orgId: orgId ?? _orgId,
);
  String? get orgName => _orgName;
  int? get orgId => _orgId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Org_Name'] = _orgName;
    map['Org_Id'] = _orgId;
    return map;
  }

}

/// Org_Name : "PARAFOX"
/// Org_Id : 16

class OrgAdmin {
  OrgAdmin({
      String? orgName, 
      int? orgId,}){
    _orgName = orgName;
    _orgId = orgId;
}

  OrgAdmin.fromJson(dynamic json) {
    _orgName = json['Org_Name'];
    _orgId = json['Org_Id'];
  }
  String? _orgName;
  int? _orgId;
OrgAdmin copyWith({  String? orgName,
  int? orgId,
}) => OrgAdmin(  orgName: orgName ?? _orgName,
  orgId: orgId ?? _orgId,
);
  String? get orgName => _orgName;
  int? get orgId => _orgId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Org_Name'] = _orgName;
    map['Org_Id'] = _orgId;
    return map;
  }

}

/// Person_Id : 141
/// FirstName : "Karan"
/// LastName : "Dataniya"
/// TOwner : "Parafox14@gmail.com"

class Profile {
  Profile({
      int? personId, 
      String? firstName, 
      String? lastName, 
      String? tOwner,}){
    _personId = personId;
    _firstName = firstName;
    _lastName = lastName;
    _tOwner = tOwner;
}

  Profile.fromJson(dynamic json) {
    _personId = json['Person_Id'];
    _firstName = json['FirstName'];
    _lastName = json['LastName'];
    _tOwner = json['TOwner'];
  }
  int? _personId;
  String? _firstName;
  String? _lastName;
  String? _tOwner;
Profile copyWith({  int? personId,
  String? firstName,
  String? lastName,
  String? tOwner,
}) => Profile(  personId: personId ?? _personId,
  firstName: firstName ?? _firstName,
  lastName: lastName ?? _lastName,
  tOwner: tOwner ?? _tOwner,
);
  int? get personId => _personId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get tOwner => _tOwner;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Person_Id'] = _personId;
    map['FirstName'] = _firstName;
    map['LastName'] = _lastName;
    map['TOwner'] = _tOwner;
    return map;
  }

}