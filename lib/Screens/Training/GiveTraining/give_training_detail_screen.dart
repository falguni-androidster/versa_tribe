import 'package:flutter/material.dart';
import 'package:versa_tribe/Screens/Training/GiveTraining/training_details_screen.dart';
import 'package:versa_tribe/Screens/Training/GiveTraining/training_joined_member_screen.dart';
import 'package:versa_tribe/Screens/Training/GiveTraining/training_pending_request_screen.dart';
import 'package:versa_tribe/extension.dart';

class GiveTrainingDetailScreen extends StatefulWidget {

  final GiveTrainingDataModel trainingResponse;

  const GiveTrainingDetailScreen({super.key, required this.trainingResponse});

  @override
  State<GiveTrainingDetailScreen> createState() => _GiveTrainingDetailScreenState();
}

class _GiveTrainingDetailScreenState extends State<GiveTrainingDetailScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    debugPrint("-->give training detail data --->${widget.trainingResponse.toJson()}");
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios,
              color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.manageTraining,
            style: TextStyle(
                color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      backgroundColor: CustomColors.kWhiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.005,
                horizontal: size.width * 0.02,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: CustomColors.kBlueColor, // Change the color of the selected tab here
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                    labelStyle: const TextStyle(fontSize: 14, color : CustomColors.kWhiteColor,fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                    tabs: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.trainingDetails)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.joinedMembers)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.pendingRequests)
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[

                /// Manage Training
                TrainingDetailScreen(trainingResponse: widget.trainingResponse),

                /// Joined Members
                TrainingJoinedMemberScreen(trainingResponse: widget.trainingResponse),

                /// Pending Requests
                TrainingPendingRequestScreen(trainingResponse: widget.trainingResponse)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
