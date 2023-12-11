import 'package:flutter/material.dart';
import 'package:versa_tribe/Model/training_response.dart';

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