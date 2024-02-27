class SwitchDataModel {
  Profile? profile;
  List<OrgAdmin>? orgAdmin;
  List<OrgPerson>? orgPerson;
  List<OrgAdminPersonList>? orgAdminPersonList;

  SwitchDataModel(
      {this.profile, this.orgAdmin, this.orgPerson, this.orgAdminPersonList});

  SwitchDataModel.fromJson(Map<String, dynamic> json) {
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['OrgAdmin'] != null) {
      orgAdmin = <OrgAdmin>[];
      json['OrgAdmin'].forEach((v) {
        orgAdmin!.add(new OrgAdmin.fromJson(v));
      });
    }
    if (json['OrgPerson'] != null) {
      orgPerson = <OrgPerson>[];
      json['OrgPerson'].forEach((v) {
        orgPerson!.add(new OrgPerson.fromJson(v));
      });
    }
    if (json['OrgAdminPersonList'] != null) {
      orgAdminPersonList = <OrgAdminPersonList>[];
      json['OrgAdminPersonList'].forEach((v) {
        orgAdminPersonList!.add(new OrgAdminPersonList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.orgAdmin != null) {
      data['OrgAdmin'] = this.orgAdmin!.map((v) => v.toJson()).toList();
    }
    if (this.orgPerson != null) {
      data['OrgPerson'] = this.orgPerson!.map((v) => v.toJson()).toList();
    }
    if (this.orgAdminPersonList != null) {
      data['OrgAdminPersonList'] =
          this.orgAdminPersonList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Profile {
  int? personId;
  String? firstName;
  String? lastName;
  String? tOwner;

  Profile({this.personId, this.firstName, this.lastName, this.tOwner});

  Profile.fromJson(Map<String, dynamic> json) {
    personId = json['Person_Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    tOwner = json['TOwner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Person_Id'] = this.personId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['TOwner'] = this.tOwner;
    return data;
  }
}

class OrgAdmin {
  String? orgName;
  int? orgId;

  OrgAdmin({this.orgName, this.orgId});

  OrgAdmin.fromJson(Map<String, dynamic> json) {
    orgName = json['Org_Name'];
    orgId = json['Org_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Org_Name'] = this.orgName;
    data['Org_Id'] = this.orgId;
    return data;
  }
}

class OrgPerson {
  String? orgName;
  int? orgId;
  bool? isCaller;

  OrgPerson({this.orgName, this.orgId, this.isCaller});

  OrgPerson.fromJson(Map<String, dynamic> json) {
    orgName = json['Org_Name'];
    orgId = json['Org_Id'];
    isCaller = json['IsCaller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Org_Name'] = this.orgName;
    data['Org_Id'] = this.orgId;
    data['IsCaller'] = this.isCaller;
    return data;
  }
}

class OrgAdminPersonList {
  String? orgType;
  String? orgName;
  int? orgId;
  bool? isAdmin;
  bool? isCaller;

  OrgAdminPersonList(
      {this.orgType, this.orgName, this.orgId, this.isAdmin, this.isCaller});

  OrgAdminPersonList.fromJson(Map<String, dynamic> json) {
    orgType = json['OrgType'];
    orgName = json['Org_Name'];
    orgId = json['Org_Id'];
    isAdmin = json['IsAdmin'];
    isCaller = json['IsCaller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrgType'] = this.orgType;
    data['Org_Name'] = this.orgName;
    data['Org_Id'] = this.orgId;
    data['IsAdmin'] = this.isAdmin;
    data['IsCaller'] = this.isCaller;
    return data;
  }
}
