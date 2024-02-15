import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/extension.dart';

class AcceptedTrainingScreen extends StatefulWidget {
  final int? orgId;
  const AcceptedTrainingScreen({super.key, required this.orgId});
  @override
  State<AcceptedTrainingScreen> createState() => _AcceptedTrainingScreenState();
}
class _AcceptedTrainingScreenState extends State<AcceptedTrainingScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      apiConfig.getAcceptedTraining(context: context, isJoin: true,orgId: widget.orgId);
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
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<AcceptTrainingListProvider>(
                  builder: (context, val, child) {
                    return val.getAcceptedTrainingList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getAcceptedTrainingList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.symmetric(horizontal: size.width*0.03,vertical: size.height*0.01),
                            child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.height*0.01),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins'),
                                              children: [
                                                const TextSpan(
                                                  text: 'You joined in ',
                                                ),
                                                TextSpan(
                                                  text: val.getAcceptedTrainingList[index].trainingName,
                                                  style: const TextStyle(
                                                    color: Colors.blue, // Change this to the color you desire
                                                    // You can apply other styles specific to this part of the text if needed
                                                  ),
                                                ),
                                                const TextSpan(text: ' Training'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          SharedPreferences pref = await SharedPreferences.getInstance();
                                          String? myPerID = pref.getSharedPrefStringValue(key: CustomString.personId);
                                          apiConfig.deletePendingTrainingRequest(context: context, trainingId: val.getAcceptedTrainingList[index].trainingId,personId: myPerID);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: CustomColors.kGrayColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            )),
                                        child: const Text(
                                          CustomString.leave,
                                          style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    ) : SizedBox(
                        width: size.width,
                        height: defaultTargetPlatform == TargetPlatform.iOS ? size.height * 0.21 : size.height * 0.25,
                        child: Center(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(ImagePath.noData, fit: BoxFit.fill),
                                const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                              ]),
                        ));
                  });
            } else {
              debugPrint("-----Accepted Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
