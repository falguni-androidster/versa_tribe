import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageOrgMember/approved_member_screen.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageOrgMember/pending_requested_member_screen.dart';
import 'package:versa_tribe/extension.dart';

class ManageOrgMembers extends StatefulWidget {

  final String orgNAME;
  final int orgID;

  const ManageOrgMembers({super.key, required this.orgNAME,required this.orgID});

  @override
  State<ManageOrgMembers> createState() => _ManageOrgMembersState();
}
class _ManageOrgMembersState extends State<ManageOrgMembers> with SingleTickerProviderStateMixin {
  // define your tab controller here
  late TabController _tabController;

  @override
  void initState() {
    // initialise your tab controller here
    _tabController = TabController(length: 2, vsync: this);
    apiConfig.getDepartment(context: context,orgId: widget.orgID);
    super.initState();
  }

  // Call this when the user pull down the screen
    Future<void> _loadData() async {
      try {
        apiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 0);
        apiConfig.getOrgMemberData(context: context,orgName: widget.orgNAME, tabIndex: 1);
      } catch (err) {
        rethrow;
      }
    }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: InkWell(
          child:
          const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
          onTap: () async {
            Navigator.pop(context);
          },
        ),
        title: const Text(CustomString.manageOrgMember, style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.02, left: size.width * 0.02, right: size.height * 0.02),
              child: Consumer<IndexProvider>(builder: (context, val, child) {
                return TabBar(
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: CustomColors.kBlueColor, // Change the color of the selected tab here
                  ),
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                  tabAlignment: TabAlignment.start,
                  labelStyle: const TextStyle(fontSize: 14, color : CustomColors.kWhiteColor,fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
                  tabs: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(CustomString.pendingRequested)
                    ),
                    Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(CustomString.approved)
                    ),
                  ],
                );
              }),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[

                  ///Pending Requested
                  PendingRequestedOrgMembersScreen(orgNAME: widget.orgNAME, orgID: widget.orgID),

                  ///Approved
                  ApprovedMemberScreen(orgNAME: widget.orgNAME, orgID: widget.orgID)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
