import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ManageTrainingJoinedMemberScreen extends StatefulWidget {
  final TakeTrainingDataModel trainingResponse;
  const ManageTrainingJoinedMemberScreen({super.key, required this.trainingResponse});
  @override
  State<ManageTrainingJoinedMemberScreen> createState() => _ManageTrainingJoinedMemberScreenState();
}

class _ManageTrainingJoinedMemberScreenState extends State<ManageTrainingJoinedMemberScreen> {
  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getTrainingJoinedMembers(context, widget.trainingResponse.trainingId, true);
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
                return Consumer<TrainingJoinedMembersProvider>(
                    builder: (context, val, child) {
                      return val.trainingJoinedMembers.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: val.trainingJoinedMembers.length,
                          itemBuilder: (context, index) {
                            return containerJoinedMembers(val.trainingJoinedMembers[index],size);
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
      ),
    );
  }

  /// Training Joined Members Container
  Widget containerJoinedMembers(TrainingJoinedMembersModel trainingJoinedMembersModel,size) {
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
                         TextSpan(text: '${trainingJoinedMembersModel.firstName} ${trainingJoinedMembersModel.lastName} is joined in '),
                        TextSpan(
                          text: trainingJoinedMembersModel.trainingName, style: const TextStyle(color: CustomColors.kBlueColor,fontSize: 14, fontFamily: 'Poppins'),
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
                  ApiConfig.deletePendingTrainingRequest(context: context, trainingId: trainingJoinedMembersModel.trainingId, personId:trainingJoinedMembersModel.personId );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.kGrayColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                child: const Text(
                 "Remove",
                  style: TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
