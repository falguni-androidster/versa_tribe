import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';
import '../../../Providers/dropmenu_provider.dart';
import 'manage_training_details_screen.dart';
import 'orgadmin_manage_training_joined_member_screen.dart';
import 'manage_training_pending_request_screen.dart';

class OrgManageTrainingDetailScreen extends StatefulWidget {
  final TakeTrainingDataModel trainingResponse;
  const OrgManageTrainingDetailScreen({super.key, required this.trainingResponse});
  @override
  State<OrgManageTrainingDetailScreen> createState() => _OrgManageTrainingDetailScreenState();
}
class _OrgManageTrainingDetailScreenState extends State<OrgManageTrainingDetailScreen> with SingleTickerProviderStateMixin {
  var menuItems = [
    'Pending Request',
    'Joined Members',
  ];
  @override
  Widget build(BuildContext context) {
    final dropMenuPro = Provider.of<DropMenuProvider>(context,listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios,
              color: CustomColors.kBlackColor),
          onTap: () {
            Navigator.pop(context);
            dropMenuPro.setOrgTrainDropMenuVisibility(0);
            dropMenuPro.setOrgTrainTDropMenu("Pending Request");
          },
        ),
        title: const Text(CustomString.manageTraining,
            style: TextStyle(
                color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      backgroundColor: CustomColors.kWhiteColor,
      body: DefaultTabController(
        length: 2,
        child: Column(
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
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: CustomColors.kBlueColor, // Change the color of the selected tab here
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelStyle: const TextStyle(fontSize: 14,
                          color: CustomColors.kBlackColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins'),
                      labelStyle: const TextStyle(fontSize: 14,
                          color: CustomColors.kWhiteColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins'),
                      tabs: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text("Training Details")
                        ),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text("Manage Requests")
                        ),
                        // Container(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: const Text(CustomString.pendingRequests)
                        // )
                      ],
                      onTap: (tabIndex){
                        if(tabIndex==0){
                          dropMenuPro.setOrgTrainDropMenuVisibility(0);
                          dropMenuPro.setOrgTrainTDropMenu("Pending Request");
                        }else if(tabIndex==1){
                          dropMenuPro.setOrgTrainDropMenuVisibility(1);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            Consumer<DropMenuProvider>(
                builder: (context,val,child) {
                  print("----><>-${val.orgTrainDropMenu}");
                  return val.orgTrainDropMenu ==1?
                  Container(
                    alignment: Alignment.centerRight,
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      //padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.02),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      alignment: Alignment.topRight,
                      // Initial Value
                      value: val.orgTrainTrainingMenuItems,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items: menuItems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will change button value to selected value
                      onChanged: (String? newValue) {
                        val.setOrgTrainTDropMenu(newValue);
                        val.notify();
                      },
                    ),
                  ):const SizedBox.shrink();
                }
            ),

            Expanded(
              child: Consumer<DropMenuProvider>(
                builder: (context,val,child) {
                  return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[

                      /// Training Details
                      ManageTrainingDetailScreen(trainingResponse: widget.trainingResponse),

                      /// Joined Members
                      val.orgTrainTrainingMenuItems=="Joined Members"?ManageTrainingJoinedMemberScreen(trainingResponse: widget.trainingResponse):

                      /// Pending Requests
                      ManageTrainingPendingRequestScreen(trainingResponse: widget.trainingResponse)
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
