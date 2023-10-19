class SearchSkillModel {
  int? skillId;
  String? skillName;

  SearchSkillModel({this.skillId, this.skillName});

  SearchSkillModel.fromJson(Map<String, dynamic> json) {
    skillId = json['Skill_Id'];
    skillName = json['Skill_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Skill_Id'] = skillId;
    data['Skill_Name'] = skillName;
    return data;
  }
}