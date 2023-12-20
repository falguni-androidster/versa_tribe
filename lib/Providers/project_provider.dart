import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

/// ProjectListProvider class
class ProjectListProvider with ChangeNotifier{
  final List<ProjectResponseModel> _getProjectList = [];
  List<ProjectResponseModel> get getProjectList => _getProjectList;

  setListProject(listProject){
    listProject.forEach((ob){
      _getProjectList.add(ProjectResponseModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// ProjectExperienceProvider class
class ProjectExperienceProvider with ChangeNotifier{
  final List<ProjectExperienceModel> _projectEx =[];
  List<ProjectExperienceModel> get projectEx => _projectEx;

  setProjectEx(pEx){
    pEx.forEach((ob) async {
      _projectEx.add(ProjectExperienceModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// ProjectQualificationProvider class
class ProjectQualificationProvider with ChangeNotifier{
  final List<ProjectQualificationModel> _projectQua =[];
  List<ProjectQualificationModel> get projectQua => _projectQua;

  setProjectQua(pQua){
    pQua.forEach((ob) async {
      _projectQua.add(ProjectQualificationModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// ProjectSkillProvider class
class ProjectSkillProvider with ChangeNotifier{
  final List<ProjectSkillModel> _projectSkill =[];
  List<ProjectSkillModel> get projectSkill => _projectSkill;

  setProjectSkill(pSkill){
    pSkill.forEach((ob) async {
      _projectSkill.add(ProjectSkillModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// ProjectHobbyProvider class
class ProjectHobbyProvider with ChangeNotifier{
  final List<ProjectHobbyModel> _projectHobby =[];
  List<ProjectHobbyModel> get projectHobby => _projectHobby;

  setProjectHobby(pHobby){
    pHobby.forEach((ob) async {
      _projectHobby.add(ProjectHobbyModel.fromJson(ob));
      notifyListeners();
    });
  }
}