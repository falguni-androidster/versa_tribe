class RequestedTrainingModel {
  int? trainingId;
  String? trainingName;
  bool? isJoin;

  RequestedTrainingModel({this.trainingId, this.trainingName, this.isJoin});

  RequestedTrainingModel.fromJson(Map<String, dynamic> json) {
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