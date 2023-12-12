class TrainingSkillModel {
  int? skillsCriteriaId;
  int? skillId;
  String? skillName;
  int? experience;
  int? status;
  String? tStamp;
  String? tOwner;
  bool? mandatory;

  TrainingSkillModel(
      {this.skillsCriteriaId,
        this.skillId,
        this.skillName,
        this.experience,
        this.status,
        this.tStamp,
        this.tOwner,
        this.mandatory});

  TrainingSkillModel.fromJson(Map<String, dynamic> json) {
    skillsCriteriaId = json['Skills_Criteria_Id'];
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
    data['Skills_Criteria_Id'] = skillsCriteriaId;
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