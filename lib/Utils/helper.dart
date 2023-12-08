import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_string.dart';

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

showRemoveConfirmation({context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(CustomString.deleteTitle, style: TextStyle(fontFamily: 'Poppins')),
        content: const Text(CustomString.removeContent, style: TextStyle(fontFamily: 'Poppins')),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the confirmation dialog
            },
            child: const Text(CustomString.no, style: TextStyle(fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () async {
              // Add your delete logic here
              // ApiConfig.deleteOrgRequest(context: context,orgID: val.approveOrgDataList[index].orgId,personID:val.approveOrgDataList[index].personId);
            },
            child: const Text(CustomString.yes, style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      );
    },
  );
}
