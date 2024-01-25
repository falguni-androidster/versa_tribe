class ProjectListByOrgIDModel {
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
      {this.projectId,
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Project_Id'] = this.projectId;
    data['Project_Name'] = this.projectName;
    data['Person_Id'] = this.personId;
    data['Status'] = this.status;
    data['Start_Date'] = this.startDate;
    data['End_Date'] = this.endDate;
    data['TStamp'] = this.tStamp;
    data['TOwner'] = this.tOwner;
    data['Org_Id'] = this.orgId;
    data['Progress'] = this.progress;
    data['IsApproved'] = this.isApproved;
    return data;
  }
}
