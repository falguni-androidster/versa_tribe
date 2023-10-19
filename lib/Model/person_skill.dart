class PersonSkillModel {
    int? perSkId;
    String? firstName;
    String? tOwner;
    String? skillName;
    String? skillField;
    int? experience;
    int? status;
    String? tStamp;

    PersonSkillModel(
        {this.perSkId,
            this.firstName,
            this.tOwner,
            this.skillName,
            this.skillField,
            this.experience,
            this.status,
            this.tStamp});

    PersonSkillModel.fromJson(Map<String, dynamic> json) {
        perSkId = json['PerSk_Id'];
        firstName = json['FirstName'];
        tOwner = json['TOwner'];
        skillName = json['Skill_Name'];
        skillField = json['Skill_Field'];
        experience = json['Experience'];
        status = json['Status'];
        tStamp = json['TStamp'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['PerSk_Id'] = perSkId;
        data['FirstName'] = firstName;
        data['TOwner'] = tOwner;
        data['Skill_Name'] = skillName;
        data['Skill_Field'] = skillField;
        data['Experience'] = experience;
        data['Status'] = status;
        data['TStamp'] = tStamp;
        return data;
    }
}