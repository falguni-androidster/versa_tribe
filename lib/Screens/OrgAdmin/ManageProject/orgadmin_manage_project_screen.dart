import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageProject/manage_project_user_screen.dart';
import 'package:versa_tribe/Screens/OrgAdmin/ManageProject/project_list_details_screen.dart';
import 'package:versa_tribe/extension.dart';
import '../../../Providers/dropmenu_provider.dart';

class OrgManageProjectDetailScreen extends StatefulWidget {
  final int orgID;
  final ProjectListByOrgIDModel projectResponseModel;
  const OrgManageProjectDetailScreen({super.key, required this.projectResponseModel,required this.orgID});
  @override
  State<OrgManageProjectDetailScreen> createState() => _OrgManageProjectDetailScreenState();
}

class _OrgManageProjectDetailScreenState extends State<OrgManageProjectDetailScreen> with SingleTickerProviderStateMixin{
  var menuItems = [
    'Pending Request',
    'Joined Members',
  ];
  @override
  Widget build(BuildContext context) {
    final dropMenuPro = Provider.of<DropMenuProvider>(context,listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: CustomColors.kGrayColor,
        leading: IconButton(
            onPressed: () {Navigator.pop(context);
            dropMenuPro.setOrgProjectDropMenuVisibility(0);
            dropMenuPro.setOrgProjectTDropMenu("Pending Request");
              },
            icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor) //replace with our own icon data.
        ),
        centerTitle: true,
        title: const Text(CustomString.manageProject,
            style: TextStyle(color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
      ),
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
                      onTap: (tabIndex){
                        if(tabIndex==0){
                          dropMenuPro.setOrgProjectDropMenuVisibility(0);
                          dropMenuPro.setOrgProjectTDropMenu("Pending Request");
                        }else if(tabIndex==1){
                          dropMenuPro.setOrgProjectDropMenuVisibility(1);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            Consumer<DropMenuProvider>(
                builder: (context,val,child) {
                  return val.orgProjectDropMenu ==1?
                  Container(
                    alignment: Alignment.centerRight,
                    child: DropdownButton(
                      dropdownColor: Colors.white,
                      //padding: EdgeInsets.symmetric(vertical: size.height*0.02,horizontal: size.width*0.02),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      alignment: Alignment.topRight,
                      // Initial Value
                      value: val.orgProjectMenuItems,
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
                        val.setOrgProjectTDropMenu(newValue);
                        val.notify();
                      },
                    ),
                  ):const SizedBox.shrink();
                }
            ),

            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ProjectOrgIdListScreen(projectResponseModel: widget.projectResponseModel),
                  ManageUserProjectScreen(projectResponseModel: widget.projectResponseModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
