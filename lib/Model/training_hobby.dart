class TrainingHobbyModel {
  int? hobbyCriteriaId;
  int? hobbyId;
  String? hobbyName;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  TrainingHobbyModel(
      {this.hobbyCriteriaId,
        this.hobbyId,
        this.hobbyName,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  TrainingHobbyModel.fromJson(Map<String, dynamic> json) {
    hobbyCriteriaId = json['Hobby_Criteria_Id'];
    hobbyId = json['Hobby_Id'];
    hobbyName = json['HobbyName'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Hobby_Criteria_Id'] = hobbyCriteriaId;
    data['Hobby_Id'] = hobbyId;
    data['HobbyName'] = hobbyName;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}