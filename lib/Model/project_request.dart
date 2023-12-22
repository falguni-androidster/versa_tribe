class ProjectRequestModel {
  int? id;
  int? projectId;
  String? projectName;
  bool? isApproved;

  ProjectRequestModel(
      {this.id, this.projectId, this.projectName, this.isApproved});

  ProjectRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    projectId = json['Project_Id'];
    projectName = json['Project_Name'];
    isApproved = json['IsApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Project_Id'] = projectId;
    data['Project_Name'] = projectName;
    data['IsApproved'] = isApproved;
    return data;
  }
}