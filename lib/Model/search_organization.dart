class SearchOrgModel {
  String? orgName;
  int? orgId;

  SearchOrgModel({this.orgName, this.orgId});

  SearchOrgModel.fromJson(Map<String, dynamic> json) {
    orgName = json['Org_Name'];
    orgId = json['Org_Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Org_Name'] = orgName;
    data['Org_Id'] = orgId;
    return data;
  }
}