import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

///check internet connectivity in our app
String connection(context){
  final provider = Provider.of<CheckInternet>(context,listen:false);
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    debugPrint("Network connection------->$result");
      provider.checkConnectivity(result);
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
  static const dateFormat = 'dd/MM/yyyy';
  String formattedDate(DateTime dateTime) {
    debugPrint('dateTime ($dateTime)');
    return DateFormat(dateFormat).format(dateTime);
  }
}

showRemoveConfirmation({context, indexedOrgId, personId, orgName, orgId, screen}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //title: const Text(CustomString.deleteTitle, style: TextStyle(fontFamily: 'Poppins')),
        content: const Text(CustomString.removeContent, style: TextStyle(fontFamily: 'Poppins')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the confirmation dialog
            },
            child: const Text(CustomString.no, style: TextStyle(fontFamily: 'Poppins',color: CustomColors.kLightGrayColor)),
          ),
          TextButton(
            onPressed: () async {
              // Add your delete logic here
              ApiConfig.deleteOrgFromAdminSide(context: context, indexedOrgID: indexedOrgId, personID: personId, orgName: orgName, orgID: orgId, screen: screen);
            },
            child: const Text(CustomString.yes, style: TextStyle(fontFamily: 'Poppins')),
          )
        ],
      );
    },
  );
}

