class SearchHobbyModel {
  int? hobbyId;
  String? name;

  SearchHobbyModel({this.hobbyId, this.name});

  SearchHobbyModel.fromJson(Map<String, dynamic> json) {
    hobbyId = json['Hobby_Id'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Hobby_Id'] = this.hobbyId;
    data['Name'] = this.name;
    return data;
  }
}