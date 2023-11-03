import 'package:flutter/material.dart';
import 'package:versa_tribe/Model/login_response.dart';

///LoginDataProvider class
class LoginDataProvider with ChangeNotifier{
  LoginResponseModel? _loginData;
  LoginResponseModel? get loginData => _loginData;

  setUserLoginData(data){
    _loginData = data;
    /*   data.forEach((ob) async {
      _loginData.add(LoginResponseModel.fromJson(ob));
      notifyListeners();
    });*/
    notifyListeners();
  }


  List<String> _data = [];
  List<String> get data=>_data;

  setdata(data){
    _data.add(data);
  }
}