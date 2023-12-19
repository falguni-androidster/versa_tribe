class ProjectQualificationModel {
  int? projQualId;
  int? projectId;
  int? couId;
  String? couName;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  ProjectQualificationModel(
      {this.projQualId,
        this.projectId,
        this.couId,
        this.couName,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  ProjectQualificationModel.fromJson(Map<String, dynamic> json) {
    projQualId = json['Proj_Qual_Id'];
    projectId = json['Project_Id'];
    couId = json['Cou_Id'];
    couName = json['Cou_Name'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Proj_Qual_Id'] = projQualId;
    data['Project_Id'] = projectId;
    data['Cou_Id'] = couId;
    data['Cou_Name'] = couName;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}