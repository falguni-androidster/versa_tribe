class SearchIndustryModel {
  int? expId;
  String? industryFieldName;

  SearchIndustryModel({this.expId, this.industryFieldName});

  SearchIndustryModel.fromJson(Map<String, dynamic> json) {
    expId = json['Exp_Id'];
    industryFieldName = json['Industry_Field_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Exp_Id'] = this.expId;
    data['Industry_Field_Name'] = this.industryFieldName;
    return data;
  }
}