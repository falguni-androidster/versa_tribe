import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:versa_tribe/extension.dart';

class TrainingJoinedMemberScreen extends StatefulWidget {

  final GiveTrainingResponse trainingResponse;

  const TrainingJoinedMemberScreen({super.key, required this.trainingResponse});

  @override
  State<TrainingJoinedMemberScreen> createState() => _TrainingJoinedMemberScreenState();
}

class _TrainingJoinedMemberScreenState extends State<TrainingJoinedMemberScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: ApiConfig.getTrainingJoinedMembers(context, widget.trainingResponse.trainingId, true),
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
              return Consumer<TrainingJoinedMembersProvider>(
                  builder: (context, val, child) {
                    return val.trainingJoinedMembers.isNotEmpty ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: val.trainingJoinedMembers.length,
                      itemBuilder: (context, index) {
                        return containerJoinedMembers(val.trainingJoinedMembers[index]);
                      }
                    ) : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.02),
                          SizedBox(height: size.height * 0.2, width: size.width / 1.5, child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                          SizedBox(height: size.height * 0.2),
                          const Text(CustomString.noDataFound, style: TextStyle(color: CustomColors.kLightGrayColor))
                        ]),
                    );
                  });
            }
            else{
              debugPrint("-----Joined Members print future builder else------");
            }
            return Container();
          }),
    );
  }

  /// Training Joined Members Container
  Widget containerJoinedMembers(TrainingJoinedMembersModel trainingJoinedMembersModel) {
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
                          text: '${trainingJoinedMembersModel.firstName} ${trainingJoinedMembersModel.lastName} is joined in ',
                        ),
                        TextSpan(
                          text: trainingJoinedMembersModel.trainingName,
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
                onPressed: () {
                  ApiConfig.deleteRequestTraining(context: context, trainingId: trainingJoinedMembersModel.trainingId);
                  },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.kGrayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: const Text(
                  CustomString.leave,
                  style: TextStyle(fontSize: 12, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
