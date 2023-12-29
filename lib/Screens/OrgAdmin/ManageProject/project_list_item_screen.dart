import 'package:flutter/material.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageProject/manage_project_user_screen.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageProject/project_list_details_screen.dart';
import 'package:versa_tribe/extension.dart';

class ProjectListItemScreen extends StatefulWidget {

  final ProjectListByOrgIDModel projectResponseModel;

  const ProjectListItemScreen({super.key, required this.projectResponseModel});

  @override
  State<ProjectListItemScreen> createState() => _ProjectListItemScreenState();
}

class _ProjectListItemScreenState extends State<ProjectListItemScreen> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);},
            icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageProject,
            style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
      ),
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
                          child: const Text(CustomString.projectDetails)
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(CustomString.manageUsers)
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
                ProjectOrgIdListScreen(projectResponseModel: widget.projectResponseModel),
                ManageUserProjectScreen(projectResponseModel: widget.projectResponseModel)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
