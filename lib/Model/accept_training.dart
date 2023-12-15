class AcceptedTrainingModel {
  int? trainingId;
  String? trainingName;
  bool? isJoin;

  AcceptedTrainingModel({this.trainingId, this.trainingName, this.isJoin});

  AcceptedTrainingModel.fromJson(Map<String, dynamic> json) {
    trainingId = json['Training_Id'];
    trainingName = json['Training_Name'];
    isJoin = json['Is_Join'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Training_Id'] = trainingId;
    data['Training_Name'] = trainingName;
    data['Is_Join'] = isJoin;
    return data;
  }
}