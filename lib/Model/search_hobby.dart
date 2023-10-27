class SearchHobbyModel {
  int? hobbyId;
  String? name;

  SearchHobbyModel({this.hobbyId, this.name});

  SearchHobbyModel.fromJson(Map<String, dynamic> json) {
    hobbyId = json['Hobby_Id'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Hobby_Id'] = hobbyId;
    data['Name'] = name;
    return data;
  }
}