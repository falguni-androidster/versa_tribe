import 'package:flutter/material.dart';
import 'package:versa_tribe/Model/login_response.dart';

///LoginDataProvider class
class LoginDataProvider with ChangeNotifier{
  final List<LoginResponseModel> _loginData =[];
  List<LoginResponseModel> get loginData => _loginData;

  setUserLoginData(data){
    //print("--->$pEx");
    _loginData.add(LoginResponseModel.fromJson(data));
    /*   data.forEach((ob) async {
      _loginData.add(LoginResponseModel.fromJson(ob));
      notifyListeners();
    });*/
  }
  notifyListen(){
    notifyListeners();
  }


  List<String> _data = [];
  List<String> get data=>_data;

  setdata(data){
    _data.add(data);
  }

  notify(){
    notifyListen();
  }
}