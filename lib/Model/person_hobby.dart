class PersonHobbyModel {
  int? personId;
  int? hobbyId;
  String? name;
  int? status;
  String? tOwner;
  String? tStamp;

  PersonHobbyModel(
      {this.personId,
        this.hobbyId,
        this.name,
        this.status,
        this.tOwner,
        this.tStamp});

  PersonHobbyModel.fromJson(Map<String, dynamic> json) {
    personId = json['Person_Id'];
    hobbyId = json['Hobby_Id'];
    name = json['Name'];
    status = json['Status'];
    tOwner = json['TOwner'];
    tStamp = json['TStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Person_Id'] = personId;
    data['Hobby_Id'] = hobbyId;
    data['Name'] = name;
    data['Status'] = status;
    data['TOwner'] = tOwner;
    data['TStamp'] = tStamp;
    return data;
  }
}