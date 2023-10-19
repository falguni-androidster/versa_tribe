class SearchInstituteModel {
  int? instId;
  String? instName;

  SearchInstituteModel({this.instId, this.instName});

  SearchInstituteModel.fromJson(Map<String, dynamic> json) {
    instId = json['Inst_Id'];
    instName = json['Inst_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Inst_Id'] = instId;
    data['Inst_Name'] = instName;
    return data;
  }
}