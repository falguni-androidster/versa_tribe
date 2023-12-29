import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

import 'give_training_item_screen.dart';

class GiveTrainingScreen extends StatefulWidget {

  final int? orgId;

  const GiveTrainingScreen({super.key, required this.orgId});

  @override
  State<GiveTrainingScreen> createState() => _GiveTrainingScreenState();
}

class _GiveTrainingScreenState extends State<GiveTrainingScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getGiveTrainingData(context);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
          future: ApiConfig.getGiveTrainingData(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<GiveTrainingListProvider>(
                  builder: (context, val, child) {
                    return val.getGiveTrainingList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getGiveTrainingList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            elevation: 3,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.all(size.width * 0.01),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                   /* Row(
                                      children: [
                                        Text(
                                            '${val.getGiveTrainingList[index].trainingName}',
                                            style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600, overflow: TextOverflow.fade)),
                                        const Spacer(),
                                        InkWell(
                                          child: SvgPicture.asset(ImagePath.deleteIcon, height: 20, width: 20, colorFilter: const ColorFilter.mode(CustomColors.kRedColor, BlendMode.srcIn)),
                                          onTap: () {
                                            _showDeleteConfirmation(context, val.getGiveTrainingList[index].trainingId);
                                          },
                                        ),
                                      ],
                                    ),*/
                                    Text(
                                        '${val.getGiveTrainingList[index].trainingName}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.w600, overflow: TextOverflow.fade)),
                                    Text(
                                        'Organization : ${val.getGiveTrainingList[index].orgName}',
                                        style: const TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Text(
                                        'Duration : ${DateUtil().formattedDate(DateTime.parse(val.getGiveTrainingList[index].startDate!).toLocal())} - ${DateUtil().formattedDate(DateTime.parse(val.getGiveTrainingList[index].endDate!).toLocal())}',
                                        style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    SizedBox(height: size.height * 0.01 / 2),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 2, color: CustomColors.kBlueColor),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                          'PersonLimit - ${val.getGiveTrainingList[index].personLimit}',
                                          style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                                    ),
                                  ],
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GiveTrainingItemScreen(trainingResponse: val.getGiveTrainingList[index])));
                          },
                        );
                      },
                    ) : SizedBox(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                        child: Center(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                const Text(CustomString.noTrainingFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                              ]),
                        ));
                  });
            } else {
              debugPrint("-----Give Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }

  /*void _showDeleteConfirmation(context, trainingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(CustomString.deleteTitle,
              style: TextStyle(fontFamily: 'Poppins')),
          content: const Text(CustomString.deleteContent,
              style: TextStyle(fontFamily: 'Poppins')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text(CustomString.cancel,
                  style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () async {
                // Add your delete logic here
                ApiConfig.deleteTraining(context, trainingId);
              },
              child: const Text(CustomString.delete,
                  style: TextStyle(fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }*/

}
