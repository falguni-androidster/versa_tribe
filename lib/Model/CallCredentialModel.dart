class CallCredentialModel {
  CallCredentialModel({
      int? orgId, 
      String? orgName, 
      bool? isCaller, 
      String? iPAddress, 
      String? extensionSrvId, 
      String? secret, 
      String? serverDomain, 
      int? extensionId, 
      String? userName,}){
    _orgId = orgId;
    _orgName = orgName;
    _isCaller = isCaller;
    _iPAddress = iPAddress;
    _extensionSrvId = extensionSrvId;
    _secret = secret;
    _serverDomain = serverDomain;
    _extensionId = extensionId;
    _userName = userName;
}

  CallCredentialModel.fromJson(dynamic json) {
    _orgId = json['Org_Id'];
    _orgName = json['Org_Name'];
    _isCaller = json['IsCaller'];
    _iPAddress = json['IP_Address'];
    _extensionSrvId = json['Extension_Srv_Id'];
    _secret = json['Secret'];
    _serverDomain = json['Server_Domain'];
    _extensionId = json['Extension_Id'];
    _userName = json['UserName'];
  }
  int? _orgId;
  String? _orgName;
  bool? _isCaller;
  String? _iPAddress;
  String? _extensionSrvId;
  String? _secret;
  String? _serverDomain;
  int? _extensionId;
  String? _userName;
CallCredentialModel copyWith({  int? orgId,
  String? orgName,
  bool? isCaller,
  String? iPAddress,
  String? extensionSrvId,
  String? secret,
  String? serverDomain,
  int? extensionId,
  String? userName,
}) => CallCredentialModel(  orgId: orgId ?? _orgId,
  orgName: orgName ?? _orgName,
  isCaller: isCaller ?? _isCaller,
  iPAddress: iPAddress ?? _iPAddress,
  extensionSrvId: extensionSrvId ?? _extensionSrvId,
  secret: secret ?? _secret,
  serverDomain: serverDomain ?? _serverDomain,
  extensionId: extensionId ?? _extensionId,
  userName: userName ?? _userName,
);
  int? get orgId => _orgId;
  String? get orgName => _orgName;
  bool? get isCaller => _isCaller;
  String? get iPAddress => _iPAddress;
  String? get extensionSrvId => _extensionSrvId;
  String? get secret => _secret;
  String? get serverDomain => _serverDomain;
  int? get extensionId => _extensionId;
  String? get userName => _userName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Org_Id'] = _orgId;
    map['Org_Name'] = _orgName;
    map['IsCaller'] = _isCaller;
    map['IP_Address'] = _iPAddress;
    map['Extension_Srv_Id'] = _extensionSrvId;
    map['Secret'] = _secret;
    map['Server_Domain'] = _serverDomain;
    map['Extension_Id'] = _extensionId;
    map['UserName'] = _userName;
    return map;
  }

}
