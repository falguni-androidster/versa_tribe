import 'dart:convert';

PersonExperienceModel personExModelFromJson(String str) => PersonExperienceModel.fromJson(json.decode(str));

String personExperienceModelToJson(PersonExperienceModel data) => json.encode(data.toJson());

class PersonExperienceModel {
    int? perExpId;
    int? personId;
    int? expId;
    String? companyName;
    String? industryFieldName;
    int? expMonths;
    String? jobTitle;
    String? startDate;
    String? endDate;
    String? tStamp;
    String? tOwner;
    int? status;

    PersonExperienceModel(
        {this.perExpId,
            this.personId,
            this.expId,
            this.companyName,
            this.industryFieldName,
            this.expMonths,
            this.jobTitle,
            this.startDate,
            this.endDate,
            this.tStamp,
            this.tOwner,
            this.status});

    PersonExperienceModel.fromJson(Map<String, dynamic> json) {
        perExpId = json['PerExp_Id'];
        personId = json['Person_Id'];
        expId = json['Exp_Id'];
        companyName = json['Company_Name'];
        industryFieldName = json['Industry_Field_Name'];
        expMonths = json['Exp_months'];
        jobTitle = json['Job_Title'];
        startDate = json['Start_date'];
        endDate = json['End_Date'];
        tStamp = json['TStamp'];
        tOwner = json['TOwner'];
        status = json['Status'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['PerExp_Id'] = perExpId;
        data['Person_Id'] = personId;
        data['Exp_Id'] = expId;
        data['Company_Name'] = companyName;
        data['Industry_Field_Name'] = industryFieldName;
        data['Exp_months'] = expMonths;
        data['Job_Title'] = jobTitle;
        data['Start_date'] = startDate;
        data['End_Date'] = endDate;
        data['TStamp'] = tStamp;
        data['TOwner'] = tOwner;
        data['Status'] = status;
        return data;
    }
}
