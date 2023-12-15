class GiveTrainingResponse {
  int? trainingId;
  int? orgId;
  String? orgName;
  int? trainerId;
  String? trainingName;
  String? description;
  String? startDate;
  String? endDate;
  int? personLimit;

  GiveTrainingResponse(
      {this.trainingId,
      this.orgId,
      this.orgName,
      this.trainerId,
      this.trainingName,
      this.description,
      this.startDate,
      this.endDate,
      this.personLimit});

  GiveTrainingResponse.fromJson(Map<String, dynamic> json) {
    trainingId = json['Training_Id'];
    orgId = json['Org_Id'];
    orgName = json['Org_Name'];
    trainerId = json['Trainer_Id'];
    trainingName = json['Training_Name'];
    description = json['Description'];
    startDate = json['Start_Date'];
    endDate = json['End_Date'];
    personLimit = json['PersonLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Training_Id'] = trainingId;
    data['Org_Id'] = orgId;
    data['Org_Name'] = orgName;
    data['Trainer_Id'] = trainerId;
    data['Training_Name'] = trainingName;
    data['Description'] = description;
    data['Start_Date'] = startDate;
    data['End_Date'] = endDate;
    data['PersonLimit'] = personLimit;
    return data;
  }
}
