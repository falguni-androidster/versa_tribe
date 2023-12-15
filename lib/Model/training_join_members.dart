class TrainingJoinedMembersModel {
  int? trainingId;
  int? personId;
  String? trainingName;
  String? firstName;
  String? lastName;
  String? tOwner;
  bool? isJoin;

  TrainingJoinedMembersModel(
      {this.trainingId,
        this.personId,
        this.trainingName,
        this.firstName,
        this.lastName,
        this.tOwner,
        this.isJoin});

  TrainingJoinedMembersModel.fromJson(Map<String, dynamic> json) {
    trainingId = json['Training_Id'];
    personId = json['Person_Id'];
    trainingName = json['Training_Name'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    tOwner = json['TOwner'];
    isJoin = json['Is_Join'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Training_Id'] = trainingId;
    data['Person_Id'] = personId;
    data['Training_Name'] = trainingName;
    data['FirstName'] = firstName;
    data['LastName'] = lastName;
    data['TOwner'] = tOwner;
    data['Is_Join'] = isJoin;
    return data;
  }
}