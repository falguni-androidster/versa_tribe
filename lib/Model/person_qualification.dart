import 'dart:convert';

PersonQualificationModel personQlModelFromJson(String str) => PersonQualificationModel.fromJson(json.decode(str));

String personQlModelToJson(PersonQualificationModel data) => json.encode(data.toJson());

class PersonQualificationModel {
    int? pQId;
    String? firstName;
    String? lastName;
    String? couName;
    String? ctypName;
    String? instName;
    String? yOP;
    String? grade;
    String? city;
    String? tOwner;
    String? tStamp;
    int? status;

    PersonQualificationModel(
        {this.pQId,
            this.firstName,
            this.lastName,
            this.couName,
            this.ctypName,
            this.instName,
            this.yOP,
            this.grade,
            this.city,
            this.tOwner,
            this.tStamp,
            this.status});

    PersonQualificationModel.fromJson(Map<String, dynamic> json) {
        pQId = json['PQ_Id'];
        firstName = json['FirstName'];
        lastName = json['LastName'];
        couName = json['Cou_Name'];
        ctypName = json['Ctyp_Name'];
        instName = json['Inst_Name'];
        yOP = json['YOP'];
        grade = json['Grade'];
        city = json['City'];
        tOwner = json['TOwner'];
        tStamp = json['TStamp'];
        status = json['Status'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['PQ_Id'] = pQId;
        data['FirstName'] = firstName;
        data['LastName'] = lastName;
        data['Cou_Name'] = couName;
        data['Ctyp_Name'] = ctypName;
        data['Inst_Name'] = instName;
        data['YOP'] = yOP;
        data['Grade'] = grade;
        data['City'] = city;
        data['TOwner'] = tOwner;
        data['TStamp'] = tStamp;
        data['Status'] = status;
        return data;
    }
}
