import 'dart:convert';

PersonQualificationModel personQlModelFromJson(String str) => PersonQualificationModel.fromJson(json.decode(str));

String personQlModelToJson(PersonQualificationModel data) => json.encode(data.toJson());

class PersonQualificationModel {
    PersonQualificationModel({
        required this.status,
        required this.tStamp,
        required this.ctypName,
        required this.pqId,
        required this.firstName,
        required this.instName,
        required this.tOwner,
        required this.couName,
        required this.grade,
        required this.lastName,
        required this.yop,
    });

    int status;
    DateTime tStamp;
    String ctypName;
    int pqId;
    String firstName;
    String instName;
    String tOwner;
    String couName;
    String grade;
    String lastName;
    DateTime yop;

    factory PersonQualificationModel.fromJson(Map<dynamic, dynamic> json) => PersonQualificationModel(
        status: json["Status"],
        tStamp: DateTime.parse(json["TStamp"]),
        ctypName: json["Ctyp_Name"],
        pqId: json["PQ_Id"],
        firstName: json["FirstName"],
        instName: json["Inst_Name"],
        tOwner: json["TOwner"],
        couName: json["Cou_Name"],
        grade: json["Grade"],
        lastName: json["LastName"],
        yop: DateTime.parse(json["YOP"]),
    );

    Map<dynamic, dynamic> toJson() => {
        "Status": status,
        "TStamp": tStamp.toIso8601String(),
        "Ctyp_Name": ctypName,
        "PQ_Id": pqId,
        "FirstName": firstName,
        "Inst_Name": instName,
        "TOwner": tOwner,
        "Cou_Name": couName,
        "Grade": grade,
        "LastName": lastName,
        "YOP": yop.toIso8601String(),
    };
}
