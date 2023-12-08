import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';


///PersonExperienceProvider class
class PersonExperienceProvider with ChangeNotifier{
  final List<PersonExperienceModel> _personEx =[];
  List<PersonExperienceModel> get personEx => _personEx;

  setPersonEx(pEx){
    pEx.forEach((ob) async {
      _personEx.add(PersonExperienceModel.fromJson(ob));
      notifyListeners();
    });
  }
  notifyListen(){
    notifyListeners();
  }
}


///PersonQualificationProvider class
class PersonQualificationProvider with ChangeNotifier{
  final List<PersonQualificationModel> _personQl =[];
  List<PersonQualificationModel> get personQl => _personQl;

  setPersonQl(pQualification){
    //print("QL--->$pQualification");
    pQualification.forEach((ob){
      _personQl.add(PersonQualificationModel.fromJson(ob));
      notifyListeners();
    });
  }
}


///PersonSkillProvider class
class PersonSkillProvider with ChangeNotifier{
  final List<PersonSkillModel> _personSkill =[];
  List<PersonSkillModel> get personSkill => _personSkill;

  setPersonSkill(pHobby){
    //print("SkillFromProvider----->$pSkill");
    pHobby.forEach((ob){
      _personSkill.add(PersonSkillModel.fromJson(ob));
      notifyListeners();
    });
  }
}


///PersonHobbyProvider class
class PersonHobbyProvider with ChangeNotifier{
  final List<PersonHobbyModel> _personHobby =[];
  List<PersonHobbyModel> get personHobby => _personHobby;

  setPersonHobby(pHobby){
    //print("HobbyFromProvider----->$pHobby");
    pHobby.forEach((ob){
      _personHobby.add(PersonHobbyModel.fromJson(ob));
      notifyListeners();
    });
  }
}

///DepartmentProvider class
class DepartmentProvider with ChangeNotifier{
  final List<DepartmentModel> _department =[];
  List<DepartmentModel> get department => _department;

  setDepartment(departmentsData){
    departmentsData.forEach((ob){
      _department.add(DepartmentModel.fromJson(ob));
      notifyListeners();
    });
  }

///--------------------------------------------------
  bool _visible = false;
  bool get visible => _visible;
  bool _visibilitySearch = false;
  bool get visibilitySearch => _visibilitySearch;

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
  setVisibilitySearchList(val) {
    _visibilitySearch = val;
  }
  notify(){
    notifyListeners();
  }
}


///Search Course data for Qualification add field class
class SearchCourseProvider with ChangeNotifier{
  final List<SearchCourseModel> _courseList =[];
  List<SearchCourseModel> get courseList => _courseList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedCourse(courseName){
    courseName.forEach((ob){
      _courseList.add(SearchCourseModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchInstituteProvider with ChangeNotifier{
  final List<SearchInstituteModel> _instituteList =[];
  List<SearchInstituteModel> get instituteList => _instituteList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedInstitute(courseName){
    courseName.forEach((ob){
      _instituteList.add(SearchInstituteModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchSkillProvider with ChangeNotifier{
  final List<SearchSkillModel> _skillList =[];
  List<SearchSkillModel> get skillList => _skillList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedSkill(courseName){
    courseName.forEach((ob){
      _skillList.add(SearchSkillModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchHobbyProvider with ChangeNotifier{
  final List<SearchHobbyModel> _hobbyList =[];
  List<SearchHobbyModel> get hobbyList => _hobbyList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedHobby(hobbyName){
    hobbyName.forEach((ob){
      _hobbyList.add(SearchHobbyModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchExCompanyProvider with ChangeNotifier{
  final List<SearchCompanyModel> _cmpList =[];
  List<SearchCompanyModel> get cmpList => _cmpList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedCompany(cmpName){
    cmpName.forEach((ob){
      _cmpList.add(SearchCompanyModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}

class SearchExIndustryProvider with ChangeNotifier{
  final List<SearchIndustryModel> _indList =[];
  List<SearchIndustryModel> get indList => _indList;
  bool _visible = false;
  bool get visible => _visible;

  setSearchedIndustry(indName){
    indName.forEach((ob){
      _indList.add(SearchIndustryModel.fromJson(ob));
      notifyListeners();
    });
  }

  setVisible(vi) {
    _visible = vi;
    notifyListeners();
  }
}


///Search department data
class SearchParentDPProvider with ChangeNotifier{
  final List<SearchDpModel> _dpList =[];
  List<SearchDpModel> get dpList => _dpList;

  setSearchedDP(dpName){
    dpName.forEach((ob){
      _dpList.add(SearchDpModel.fromJson(ob));
      notifyListeners();
    });
  }

}