class SearchCourseModel {
  int? couId;
  String? couName;

  SearchCourseModel({this.couId, this.couName});

  SearchCourseModel.fromJson(Map<String, dynamic> json) {
    couId = json['Cou_Id'];
    couName = json['Cou_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cou_Id'] = couId;
    data['Cou_Name'] = couName;
    return data;
  }
}