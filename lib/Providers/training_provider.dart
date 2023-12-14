import 'package:flutter/material.dart';
import 'package:versa_tribe/extension.dart';

/// TrainingListProvider class
class TrainingListProvider with ChangeNotifier{
  final List<TrainingResponse> _getTrainingList = [];
  List<TrainingResponse> get getTrainingList => _getTrainingList;

  setListTraining(listTraining){
    listTraining.forEach((ob){
      _getTrainingList.add(TrainingResponse.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingExperienceProvider class
class TrainingExperienceProvider with ChangeNotifier{
  final List<TrainingExperienceModel> _trainingEx =[];
  List<TrainingExperienceModel> get trainingEx => _trainingEx;

  setTrainingEx(tEx){
    tEx.forEach((ob) async {
      _trainingEx.add(TrainingExperienceModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingQualificationProvider class
class TrainingQualificationProvider with ChangeNotifier{
  final List<TrainingQualificationModel> _trainingQua =[];
  List<TrainingQualificationModel> get trainingQua => _trainingQua;

  setTrainingQua(tQua){
    tQua.forEach((ob) async {
      _trainingQua.add(TrainingQualificationModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingSkillProvider class
class TrainingSkillProvider with ChangeNotifier{
  final List<TrainingSkillModel> _trainingSkill =[];
  List<TrainingSkillModel> get trainingSkill => _trainingSkill;

  setTrainingSkill(tSkill){
    tSkill.forEach((ob) async {
      _trainingSkill.add(TrainingSkillModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingHobbyProvider class
class TrainingHobbyProvider with ChangeNotifier{
  final List<TrainingHobbyModel> _trainingHobby =[];
  List<TrainingHobbyModel> get trainingHobby => _trainingHobby;

  setTrainingHobby(tHobby){
    tHobby.forEach((ob) async {
      _trainingHobby.add(TrainingHobbyModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingJoinedMembersProvider class
class TrainingJoinedMembersProvider with ChangeNotifier{
  final List<TrainingJoinedMembersModel> _trainingJoinedMembers =[];
  List<TrainingJoinedMembersModel> get trainingJoinedMembers => _trainingJoinedMembers;

  setTrainingJoinedMembers(tJoinedMembers){
    tJoinedMembers.forEach((ob) async {
      _trainingJoinedMembers.add(TrainingJoinedMembersModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TrainingPendingRequestProvider class
class TrainingPendingRequestProvider with ChangeNotifier{
  final List<TrainingPendingRequestsModel> _trainingPendingRequests =[];
  List<TrainingPendingRequestsModel> get trainingPendingRequests => _trainingPendingRequests;

  setTrainingPendingRequests(tPendingRequests){
    tPendingRequests.forEach((ob) async {
      _trainingPendingRequests.add(TrainingPendingRequestsModel.fromJson(ob));
      notifyListeners();
    });
  }
}