import 'package:flutter/material.dart';
import 'package:versa_tribe/Model/accept_training.dart';
import 'package:versa_tribe/Model/request_training.dart';
import 'package:versa_tribe/Model/take_training_response.dart';
import 'package:versa_tribe/extension.dart';

/// GiveTrainingListProvider class
class GiveTrainingListProvider with ChangeNotifier{
  final List<GiveTrainingResponse> _getGiveTrainingList = [];
  List<GiveTrainingResponse> get getGiveTrainingList => _getGiveTrainingList;

  setGiveListTraining(listTraining){
    listTraining.forEach((ob){
      _getGiveTrainingList.add(GiveTrainingResponse.fromJson(ob));
      notifyListeners();
    });
  }
}

/// TakeTrainingListProvider class
class TakeTrainingListProvider with ChangeNotifier{
  final List<TakeTrainingResponse> _getTakeTrainingList = [];
  List<TakeTrainingResponse> get getTakeTrainingList => _getTakeTrainingList;

  setTakeListTraining(listTraining){
    listTraining.forEach((ob){
      _getTakeTrainingList.add(TakeTrainingResponse.fromJson(ob));
      notifyListeners();
    });
  }
}

/// OutgoingRequestTrainingListProvider class
class RequestTrainingListProvider with ChangeNotifier{
  final List<RequestedTrainingModel> _getRequestedTrainingList = [];
  List<RequestedTrainingModel> get getRequestedTrainingList => _getRequestedTrainingList;

  setRequestedTrainingList(listTraining){
    listTraining.forEach((ob){
      _getRequestedTrainingList.add(RequestedTrainingModel.fromJson(ob));
      notifyListeners();
    });
  }
}

/// OutgoingRequestTrainingListProvider class
class AcceptTrainingListProvider with ChangeNotifier{
  final List<AcceptedTrainingModel> _getAcceptedTrainingList = [];
  List<AcceptedTrainingModel> get getAcceptedTrainingList => _getAcceptedTrainingList;

  setAcceptedTrainingList(listTraining){
    listTraining.forEach((ob){
      _getAcceptedTrainingList.add(AcceptedTrainingModel.fromJson(ob));
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