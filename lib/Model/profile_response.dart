class ProfileResponse {
  int? personId;
  String? firstName;
  String? lastName;
  String? gender;
  String? city;
  String? country;
  String? dOJ;
  String? dOB;
  String? tStamp;
  String? tOwner;
  int? status;

  ProfileResponse(
      {this.personId,
        this.firstName,
        this.lastName,
        this.gender,
        this.city,
        this.country,
        this.dOJ,
        this.dOB,
        this.tStamp,
        this.tOwner,
        this.status});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    personId = json['Person_Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    gender = json['Gender'];
    city = json['City'];
    country = json['Country'];
    dOJ = json['DOJ'];
    dOB = json['DOB'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Person_Id'] = personId;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['Gender'] = gender;
    data['City'] = city;
    data['Country'] = country;
    data['DOJ'] = dOJ;
    data['DOB'] = dOB;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Status'] = status;
    return data;
  }
}