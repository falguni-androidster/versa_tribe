import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/Project/accepted_project_screen.dart';
import 'package:versa_tribe/Screens/Project/ongoing_project_screen.dart';
import 'package:versa_tribe/Screens/Project/requested_project_screen.dart';
import 'package:versa_tribe/extension.dart';

class ProjectScreen extends StatefulWidget {
  final int? orgId;
  const ProjectScreen({super.key, required this.orgId});
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late SharedPreferences pref;
  int? oId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getPreferenceData();
  }
  getPreferenceData() async {
    FBroadcast.instance().register("Key_Message", (value, callback) {
      var data = value;
      debugPrint("data---Broadcast---->$data");
    });

    pref = await SharedPreferences.getInstance();
    oId = pref.getSharedPrefIntValue(key: CustomString.organizationId) ?? widget.orgId;
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.02,
                right: size.height * 0.02),
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
                          child: const Text(CustomString.onGoingProject)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.requested)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.accepted)
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
                OnGoingProjectScreen(orgId: widget.orgId),
                const RequestedProjectScreen(),
                const AcceptedProjectScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

