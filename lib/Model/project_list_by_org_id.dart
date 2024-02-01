class ProjectListByOrgIDModel {
  int? id;
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
  bool? isApproved;

  ProjectListByOrgIDModel(
      {this.id,
        this.projectId,
        this.projectName,
        this.personId,
        this.status,
        this.startDate,
        this.endDate,
        this.tStamp,
        this.tOwner,
        this.orgId,
        this.progress,
        this.isApproved});

  ProjectListByOrgIDModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
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
    isApproved = json['IsApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Id'] = id;
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
    data['IsApproved'] = isApproved;
    return data;
  }
}
