import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'api_config.dart';
import 'custom_colors.dart';
import 'custom_string.dart';
import 'image_path.dart';

class TextContainerList extends StatelessWidget {
  final List<String> textData;
  final List<int> personId;
  final List<int> hobbyId;

  TextContainerList({required this.textData, required this.personId, required this.hobbyId});

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;

    List<Widget> containerWidgets = [];

    for (String hobby in textData) {
      containerWidgets.add(
        Padding(padding: EdgeInsets.only(right: mWidth * 0.01, bottom: mHeight * 0.01),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.kBlueColor, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(hobby,
                      style: const TextStyle(
                          color: CustomColors.kBlackColor, fontSize: 14)),
                  SizedBox(
                    width: mWidth * 0.01,
                  ),
                  InkWell(
                      child: SvgPicture.asset(
                        ImagePath.closeIcon,
                      ),
                      onTap: () {
                        _showDeleteConfirmation(context, "identityPHD", hobbyId[textData.indexOf(hobby)], personId[textData.indexOf(hobby)]);
                      })
                ],
              )),
        ),
      );
    }

    return Wrap(
      children: containerWidgets,
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, identityKey, int? iD, personId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(CustomString.deleteTitle),
          content: const Text(CustomString.deleteContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.cancel),
            ),
            TextButton(
              onPressed: () {
                // Add your delete logic here
                if (identityKey == "identityPED") {
                  ApiConfig.deletePersonEx(context, iD);
                } else if (identityKey == "identityPQD") {
                  ApiConfig.deletePersonQL(context, iD);
                } else if (identityKey == "identityPSD") {
                  ApiConfig.deletePersonSkill(context, iD);
                } else if (identityKey == "identityPHD") {
                  ApiConfig.deletePersonHobby(context, personId, iD);
                }
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.delete),
            ),
          ],
        );
      },
    );
  }
}
