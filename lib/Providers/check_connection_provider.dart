import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class CheckInternet extends ChangeNotifier {
  String _status = "waiting";
  String get status => _status;

  checkConnectivity(result){
    if (result == ConnectivityResult.mobile) {
      _status = "Connected";
      notifyListeners();
    } else if (result == ConnectivityResult.wifi) {
      _status = "Connected";
      notifyListeners();
    } else if(result==ConnectivityResult.none){
      _status = "Offline";
      notifyListeners();
    }
  }
}