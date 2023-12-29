import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class RequestedTrainingScreen extends StatefulWidget {
  const RequestedTrainingScreen({super.key});

  @override
  State<RequestedTrainingScreen> createState() => _RequestedTrainingScreenState();
}

class _RequestedTrainingScreenState extends State<RequestedTrainingScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getRequestedTraining(context: context, isJoin: false);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
          future: ApiConfig.getRequestedTraining(context: context, isJoin: false),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );

            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<RequestTrainingListProvider>(
                  builder: (context, val, child) {
                    return val.getRequestedTrainingList.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: val.getRequestedTrainingList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: Card(
                            color: CustomColors.kWhiteColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(6))),
                            margin: EdgeInsets.all(size.width * 0.01),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins'),
                                              children: [
                                                const TextSpan(
                                                  text: 'You requested to join ',
                                                ),
                                                TextSpan(
                                                  text: val.getRequestedTrainingList[index].trainingName,
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                ApiConfig.deleteRequestTraining(context: context, trainingId: val.getRequestedTrainingList[index].trainingId);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: CustomColors.kGrayColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                  )),
                                              child: const Text(
                                                CustomString.reject,
                                                style: TextStyle(fontSize: 12, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                ApiConfig.approveRequestTraining(context: context, trainingId: val.getRequestedTrainingList[index].trainingId);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: CustomColors.kBlueColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(6),
                                                  )),
                                              child: const Text(
                                                CustomString.approve,
                                                style: TextStyle(fontSize: 12, color: CustomColors.kWhiteColor, fontFamily: 'Poppins'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
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
              debugPrint("-----Requested Training print future builder------");
            }
            return Container();
          },
        ),
      ),
    );
  }
}
