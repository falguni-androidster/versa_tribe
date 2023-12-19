class ProjectSkillModel {
  int? projSkillCriId;
  int? skillId;
  String? skillName;
  int? experience;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  ProjectSkillModel(
      {this.projSkillCriId,
        this.skillId,
        this.skillName,
        this.experience,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  ProjectSkillModel.fromJson(Map<String, dynamic> json) {
    projSkillCriId = json['Proj_Skill_Cri_Id'];
    skillId = json['Skill_Id'];
    skillName = json['Skill_Name'];
    experience = json['Experience'];
    status = json['Status'];
    tStamp = json['TStamp'];
    tOwner = json['TOwner'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Proj_Skill_Cri_Id'] = projSkillCriId;
    data['Skill_Id'] = skillId;
    data['Skill_Name'] = skillName;
    data['Experience'] = experience;
    data['Status'] = status;
    data['TStamp'] = tStamp;
    data['TOwner'] = tOwner;
    data['Mandatory'] = mandatory;
    return data;
  }
}