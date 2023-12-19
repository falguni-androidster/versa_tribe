class ProjectExperienceModel {
  int? projExpId;
  int? expId;
  String? companyName;
  String? industryFieldName;
  int? expMonths;
  String? jobTitle;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  ProjectExperienceModel(
      {this.projExpId,
        this.expId,
        this.companyName,
        this.industryFieldName,
        this.expMonths,
        this.jobTitle,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  ProjectExperienceModel.fromJson(Map<String, dynamic> json) {
    projExpId = json['Proj_Exp_Id'];
    expId = json['Exp_Id'];
    companyName = json['Company_Name'];
    industryFieldName = json['Industry_Field_Name'];
    expMonths = json['Exp_months'];
    jobTitle = json['Job_Title'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Proj_Exp_Id'] = projExpId;
    data['Exp_Id'] = expId;
    data['Company_Name'] = companyName;
    data['Industry_Field_Name'] = industryFieldName;
    data['Exp_months'] = expMonths;
    data['Job_Title'] = jobTitle;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}