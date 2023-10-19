import 'package:flutter/cupertino.dart';

import '../Model/person_experience.dart';
import '../Model/person_hobby.dart';
import '../Model/person_qualification.dart';
import '../Model/person_skill.dart';
import '../Model/search_course.dart';
import '../Model/search_institute.dart';
import '../Model/search_skill.dart';


///PersonExperienceProvider class
class PersonExperienceProvider with ChangeNotifier{
  final List<PersonExperienceModel> _personEx =[];
  List<PersonExperienceModel> get personEx => _personEx;

  setPersonEx(pEx){
    //print("--->$pEx");
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
