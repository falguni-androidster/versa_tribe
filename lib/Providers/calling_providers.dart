import 'package:flutter/cupertino.dart';

class CallTimerProvider with ChangeNotifier{
  String _timeLabel = '00:00';
  String get callTimer=>_timeLabel;
  setCallTimer(startTime){
    _timeLabel=startTime;
    notifyListeners();
  }
}
