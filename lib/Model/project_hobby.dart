class ProjectHobbyModel {
  int? projHobbyCriId;
  int? hobbyId;
  String? hobbyName;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  ProjectHobbyModel(
      {this.projHobbyCriId,
        this.hobbyId,
        this.hobbyName,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  ProjectHobbyModel.fromJson(Map<String, dynamic> json) {
    projHobbyCriId = json['Proj_Hobby_Cri_Id'];
    hobbyId = json['Hobby_Id'];
    hobbyName = json['HobbyName'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Proj_Hobby_Cri_Id'] = projHobbyCriId;
    data['Hobby_Id'] = hobbyId;
    data['HobbyName'] = hobbyName;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}