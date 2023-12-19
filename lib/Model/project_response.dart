class ProjectResponseModel {
  int? projectId;
  String? projectName;
  int? personId;
  int? status;
  String? startDate;
  String? endDate;
  String? tStamp;
  String? tOwner;
  int? orgId;
  int? progress;

  ProjectResponseModel(
      {this.projectId,
        this.projectName,
        this.personId,
        this.status,
        this.startDate,
        this.endDate,
        this.tStamp,
        this.tOwner,
        this.orgId,
        this.progress});

  ProjectResponseModel.fromJson(Map<String, dynamic> json) {
    projectId = json['Project_Id'];
    projectName = json['Project_Name'];
    personId = json['Person_Id'];
    status = json['Status'];
    startDate = json['Start_Date'];
    endDate = json['End_Date'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    orgId = json['Org_Id'];
    progress = json['Progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Project_Id'] = projectId;
    data['Project_Name'] = projectName;
    data['Person_Id'] = personId;
    data['Status'] = status;
    data['Start_Date'] = startDate;
    data['End_Date'] = endDate;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Org_Id'] = orgId;
    data['Progress'] = progress;
    return data;
  }
}