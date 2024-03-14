import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ManageTrainingPendingRequestScreen extends StatefulWidget {
  final TakeTrainingDataModel trainingResponse;
  const ManageTrainingPendingRequestScreen({super.key, required this.trainingResponse});
  @override
  State<ManageTrainingPendingRequestScreen> createState() => _ManageTrainingPendingRequestScreenState();
}

class _ManageTrainingPendingRequestScreenState extends State<ManageTrainingPendingRequestScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      apiConfig.getTrainingPendingRequests(context, widget.trainingResponse.trainingId, false);
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
                        itemCount: val.trainingPendingRequests.length,
                        itemBuilder: (context, index) {
                          return containerPendingRequest(val.trainingPendingRequests[index],size);
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
      ),
    );
  }

  /// Training Joined Members Container
  Widget containerPendingRequest(TrainingPendingRequestsModel trainingPendingRequestsModel,size) {
    return Card(
      elevation: 3,
      color: CustomColors.kWhiteColor,
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
                        TextSpan(
                          text: '${trainingPendingRequestsModel.firstName} ${trainingPendingRequestsModel.lastName} is requested to join ',
                        ),
                        TextSpan(
                          text: trainingPendingRequestsModel.trainingName,
                          style: const TextStyle(
                            color:CustomColors.kBlueColor,fontSize: 14, fontFamily: 'Poppins'
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
                        showDeleteConfirmation(context: context, idString: "training_reject_by_organization", trainingId: trainingPendingRequestsModel.trainingId, personId:trainingPendingRequestsModel.personId, isJoin:trainingPendingRequestsModel.isJoin,dialogTitle: CustomString.rejectTRequest,dialogDisc: CustomString.rejectTRequestDesc);
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
                        apiConfig.approveRequestTraining(context: context,trainingId: trainingPendingRequestsModel.trainingId, personId:trainingPendingRequestsModel.personId, isJoin: trainingPendingRequestsModel.isJoin);
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
