class SearchOrgModel {
  String? orgName;
  int? orgId;

  SearchOrgModel({this.orgName, this.orgId});

  SearchOrgModel.fromJson(Map<String, dynamic> json) {
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