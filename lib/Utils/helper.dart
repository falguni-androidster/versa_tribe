import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/extension.dart';

/// Clear All Shared Preference
Future<void> clearSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clearSharedPreferencesKey(key: CustomString.isLoggedIn);
  prefs.clearSharedPreferencesKey(key: CustomString.accessToken);
  prefs.clearSharedPreferencesKey(key: CustomString.personId);
  prefs.clearSharedPreferencesKey(key: CustomString.organizationId);
  prefs.clearSharedPreferencesKey(key: CustomString.organizationName);
  prefs.clearSharedPreferencesKey(key: CustomString.organizationAdmin);
  prefs.clearSharedPreferencesKey(key: "selectedIndex");
}

///check internet connectivity in our app
String connection(context){
  final provider = Provider.of<CheckInternet>(context, listen:false);
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    debugPrint("Network connection------->$result");
    provider.checkConnectivity(result);
    showToast(context, '$result');
  });
  return provider.status;
}

/// Months Between Two Dates
int monthsBetweenDates(DateTime startDate, DateTime endDate) {
  int months = 0;
  while (startDate.isBefore(endDate)) {
    months++;
    startDate = DateTime(startDate.year, startDate.month + 1, startDate.day);
  }
  return months;
}

/// return days,hours,seconds ago from timeStamp
String timeAgo(String timestamp) {
  final now = DateTime.now();
  final parsedTimestamp = DateTime.parse(timestamp);
  final difference = now.difference(parsedTimestamp);

  if (difference.inSeconds < 60) {
    return

      '${difference.inSeconds} seconds ago';
  } else

  if (difference.inMinutes < 60) {
    return

      '${difference.inMinutes} minutes ago';
  } else

  if (difference.inHours < 24) {
    return

      '${difference.inHours} hours ago';
  } else

  if (difference.inDays == 1) {
    return 'Yesterday';
  } else {
    return '${difference.inDays} days ago';
  }
}

class DateUtil {
  static const dateFormat = 'yyyy/MM/dd';
  String formattedDate(DateTime dateTime) {
    debugPrint('dateTime ($dateTime)');
    return DateFormat(dateFormat).format(dateTime);
  }
}

showRemoveConfirmation({context, indexedOrgId, personId, orgName, orgId, screen,}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //title: const Text(CustomString.deleteTitle, style: TextStyle(fontFamily: 'Poppins')),
        content: const Text(CustomString.removeContent, style: TextStyle(fontFamily: 'Poppins')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              return Navigator.of(context).pop(); // Close the confirmation dialog
            },
            child: const Text(CustomString.no, style: TextStyle(fontFamily: 'Poppins',color: CustomColors.kLightGrayColor)),
          ),
          TextButton(
            onPressed: () async {
              // Add your delete logic here
              apiConfig.deleteOrgFromAdminSide(context: context, indexedOrgID: indexedOrgId, personID: personId, orgName: orgName, orgID: orgId, screen: screen);
              return;
            },
            child: const Text(CustomString.yes, style: TextStyle(fontFamily: 'Poppins')),
          )
        ],
      );
    },
  );
}

showDeleteConfirmation({context, idString, orgId, deleteID, personId, projectId, trainingId, isJoin, dialogTitle,dialogDisc}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CustomColors.kWhiteColor,
        title: Text(dialogTitle, style: const TextStyle(fontFamily: 'Poppins')),
        content:  Text(dialogDisc, style: const TextStyle(fontFamily: 'Poppins')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the confirmation dialog
            },
            child: const Text(CustomString.no, style: TextStyle(fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the confirmation dialog
              if(idString=="project_cancel"){
                ApiConfig().deleteJoinedProject(context: context, orgId:orgId, deleteID: deleteID, projectId: projectId);
              }else if(idString=="project_leave"){
                ApiConfig().deleteJoinedProject(context: context,orgId:orgId, deleteID: deleteID, projectId: projectId);
              }else if(idString=="project_reject"){
                apiConfig.cancelProjectJoinedRequest(context: context, id: deleteID, projectId: projectId);
              }else if(idString=="project_remove"){
                apiConfig.cancelProjectJoinedRequest(context: context, id: deleteID, projectId: projectId);
              }

              else if(idString=="training_leave"){
                ApiConfig().deleteJoinedTraining(context: context,orgId: orgId, trainingId: trainingId);
              } else if(idString=="training_cancel"){
                ApiConfig().deleteJoinedTraining(context: context,orgId: orgId, trainingId: trainingId);
              }else if(idString=="training_reject"){
                apiConfig.deletePendingTrainingRequest(context: context, trainingId: trainingId,personId:personId, isJoin:isJoin);
              }else if(idString=="training_remove"){
                apiConfig.deletePendingTrainingRequest(context: context, trainingId: trainingId, personId:personId);
              }else if(idString=="training_reject_by_organization"){
                apiConfig.deletePendingTrainingRequest(context: context, trainingId: trainingId,personId:personId, isJoin:isJoin);
              }else if(idString=="training_remove_by_organization"){
                apiConfig.deletePendingTrainingRequest(context: context, trainingId: trainingId, personId:personId );
              }
            },
            child: const Text(CustomString.yes, style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      );
    },
  );
}
