class TakeTrainingDataModel {
  int? trainingId;
  int? orgId;
  int? trainerId;
  String? trainingName;
  String? description;
  int? status;
  String? startDate;
  String? endDate;
  String? tStamp;
  String? tOwner;
  int? personLimit;
  String? firstName;
  String? lastName;
  String? personEmail;
  bool? isJoin;

  TakeTrainingDataModel(
      {this.trainingId,
        this.orgId,
        this.trainerId,
        this.trainingName,
        this.description,
        this.status,
        this.startDate,
        this.endDate,
        this.tStamp,
        this.tOwner,
        this.personLimit,
        this.firstName,
        this.lastName,
        this.personEmail,
        this.isJoin});

  TakeTrainingDataModel.fromJson(Map<String, dynamic> json) {
    trainingId = json['Training_Id'];
    orgId = json['Org_Id'];
    trainerId = json['Trainer_Id'];
    trainingName = json['Training_Name'];
    description = json['Description'];
    status = json['Status'];
    startDate = json['Start_Date'];
    endDate = json['End_Date'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    personLimit = json['PersonLimit'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    personEmail = json['PersonEmail'];
    isJoin = json['Is_Join'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Training_Id'] = this.trainingId;
    data['Org_Id'] = this.orgId;
    data['Trainer_Id'] = this.trainerId;
    data['Training_Name'] = this.trainingName;
    data['Description'] = this.description;
    data['Status'] = this.status;
    data['Start_Date'] = this.startDate;
    data['End_Date'] = this.endDate;
    data['TStamp'] = this.tStamp;
    data['TOwner'] = this.tOwner;
    data['PersonLimit'] = this.personLimit;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['PersonEmail'] = this.personEmail;
    data['Is_Join'] = this.isJoin;
    return data;
  }
}
