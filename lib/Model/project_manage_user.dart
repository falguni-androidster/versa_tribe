class ProjectManageUserModel {
  int? id;
  int? personId;
  String? projectName;
  String? firstName;
  bool? isApproved;

  ProjectManageUserModel(
      {this.id,
        this.personId,
        this.projectName,
        this.firstName,
        this.isApproved});

  ProjectManageUserModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    personId = json['Person_Id'];
    projectName = json['Project_Name'];
    firstName = json['FirstName'];
    isApproved = json['IsApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Person_Id'] = personId;
    data['Project_Name'] = projectName;
    data['FirstName'] = firstName;
    data['IsApproved'] = isApproved;
    return data;
  }
}