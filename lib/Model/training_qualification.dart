class TrainingQualificationModel {
  int? qualificationCriteriaId;
  int? trainingId;
  int? couId;
  String? couName;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  TrainingQualificationModel(
      {this.qualificationCriteriaId,
        this.trainingId,
        this.couId,
        this.couName,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  TrainingQualificationModel.fromJson(Map<String, dynamic> json) {
    qualificationCriteriaId = json['Qualification_Criteria_Id'];
    trainingId = json['Training_Id'];
    couId = json['Cou_Id'];
    couName = json['Cou_Name'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Qualification_Criteria_Id'] = qualificationCriteriaId;
    data['Training_Id'] = trainingId;
    data['Cou_Id'] = couId;
    data['Cou_Name'] = couName;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}