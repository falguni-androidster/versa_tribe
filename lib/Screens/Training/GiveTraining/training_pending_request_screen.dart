import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:versa_tribe/extension.dart';

class TrainingPendingRequestScreen extends StatefulWidget {

  final GiveTrainingResponse trainingResponse;

  const TrainingPendingRequestScreen({super.key, required this.trainingResponse});

  @override
  State<TrainingPendingRequestScreen> createState() => _TrainingPendingRequestScreenState();
}

class _TrainingPendingRequestScreenState extends State<TrainingPendingRequestScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: ApiConfig.getTrainingPendingRequests(context, widget.trainingResponse.trainingId, false),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return SizedBox(
                height: size.height * 0.1,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else if(snapshot.connectionState == ConnectionState.done){
              return Consumer<TrainingPendingRequestProvider>(
                  builder: (context, val, child) {
                    return val.trainingPendingRequests.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.trainingPendingRequests.length,
                      itemBuilder: (context, index) {
                        return containerPendingRequest(val.trainingPendingRequests[index]);
                      },
                    ) : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          SizedBox(height: size.height * 0.2, width: size.width / 1.5, child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                          SizedBox(height: size.height * 0.2),
                          const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor))
                        ],),
                    );
                  });
            }
            else{
              debugPrint("-----Pending Requests print future builder else------");
            }
            return Container();
          }),
    );
  }

  /// Training Joined Members Container
  Widget containerPendingRequest(TrainingPendingRequestsModel trainingPendingRequestsModel) {
    return Card(
      elevation: 3,
      color: CustomColors.kWhiteColor,
      margin: const EdgeInsets.all(4),
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
                        TextSpan(
                          text: '${trainingPendingRequestsModel.firstName} ${trainingPendingRequestsModel.lastName} is requested to join ',
                        ),
                        TextSpan(
                          text: trainingPendingRequestsModel.trainingName,
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
                        ApiConfig.deleteRequestTraining(context: context, trainingId: trainingPendingRequestsModel.trainingId);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kGrayColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: const Text(
                        CustomString.reject,
                        style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ApiConfig.approveRequestTraining(context: context,trainingId: trainingPendingRequestsModel.trainingId, isJoin: true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.kBlueColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          )),
                      child: const Text(
                        CustomString.approve,
                        style: TextStyle(fontSize: 14, color: CustomColors.kWhiteColor, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
