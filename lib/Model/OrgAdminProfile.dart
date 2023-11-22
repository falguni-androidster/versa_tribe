/// Org_Id : 16
/// About_org : "IT Solutions "
/// City : "Ahemedabad "
/// Country : "INDIA"
/// Contact_email : "parafox14@gmail.com"
/// Contact_number : "8128618178"
/// TStamp : "2023-11-21T14:45:20.1506046"
/// TOwner : "Parafox14@gmail.com"
/// Status : 1

class OrgAdminProfile {
  OrgAdminProfile({
      int? orgId, 
      String? aboutOrg, 
      String? city, 
      String? country, 
      String? contactEmail, 
      String? contactNumber, 
      String? tStamp, 
      String? tOwner, 
      int? status,}){
    _orgId = orgId;
    _aboutOrg = aboutOrg;
    _city = city;
    _country = country;
    _contactEmail = contactEmail;
    _contactNumber = contactNumber;
    _tStamp = tStamp;
    _tOwner = tOwner;
    _status = status;
}

  OrgAdminProfile.fromJson(dynamic json) {
    _orgId = json['Org_Id'];
    _aboutOrg = json['About_org'];
    _city = json['City'];
    _country = json['Country'];
    _contactEmail = json['Contact_email'];
    _contactNumber = json['Contact_number'];
    _tStamp = json['TStamp'];
    _tOwner = json['TOwner'];
    _status = json['Status'];
  }
  int? _orgId;
  String? _aboutOrg;
  String? _city;
  String? _country;
  String? _contactEmail;
  String? _contactNumber;
  String? _tStamp;
  String? _tOwner;
  int? _status;
OrgAdminProfile copyWith({  int? orgId,
  String? aboutOrg,
  String? city,
  String? country,
  String? contactEmail,
  String? contactNumber,
  String? tStamp,
  String? tOwner,
  int? status,
}) => OrgAdminProfile(  orgId: orgId ?? _orgId,
  aboutOrg: aboutOrg ?? _aboutOrg,
  city: city ?? _city,
  country: country ?? _country,
  contactEmail: contactEmail ?? _contactEmail,
  contactNumber: contactNumber ?? _contactNumber,
  tStamp: tStamp ?? _tStamp,
  tOwner: tOwner ?? _tOwner,
  status: status ?? _status,
);
  int? get orgId => _orgId;
  String? get aboutOrg => _aboutOrg;
  String? get city => _city;
  String? get country => _country;
  String? get contactEmail => _contactEmail;
  String? get contactNumber => _contactNumber;
  String? get tStamp => _tStamp;
  String? get tOwner => _tOwner;
  int? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Org_Id'] = _orgId;
    map['About_org'] = _aboutOrg;
    map['City'] = _city;
    map['Country'] = _country;
    map['Contact_email'] = _contactEmail;
    map['Contact_number'] = _contactNumber;
    map['TStamp'] = _tStamp;
    map['TOwner'] = _tOwner;
    map['Status'] = _status;
    return map;
  }

}