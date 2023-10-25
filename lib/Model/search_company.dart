class SearchCompanyModel {
  int? expId;
  String? companyName;

  SearchCompanyModel({this.expId, this.companyName});

  SearchCompanyModel.fromJson(Map<String, dynamic> json) {
    expId = json['Exp_Id'];
    companyName = json['Company_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['Exp_Id'] = expId;
    data['Company_Name'] = companyName;
    return data;
  }
}