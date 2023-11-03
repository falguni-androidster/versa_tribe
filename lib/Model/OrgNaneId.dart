/// Org_Name : "ABCDE"
/// Org_Id : 9

class OrgNameId {
  OrgNameId({
    String? orgName,
    int? orgId,
  }) {
    _orgName = orgName;
    _orgId = orgId;
  }

  OrgNameId.fromJson(dynamic json) {
    _orgName = json['Org_Name'];
    _orgId = json['Org_Id'];
  }

  String? _orgName;
  int? _orgId;

  OrgNameId copyWith({
    String? orgName,
    int? orgId,
  }) =>
      OrgNameId(
        orgName: orgName ?? _orgName,
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
