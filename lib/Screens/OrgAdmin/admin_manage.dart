import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:versa_tribe/Screens/OrgAdmin/manage_training.dart';
import 'package:versa_tribe/Screens/OrgAdmin/update_admin_profile.dart';
import 'package:versa_tribe/Screens/Training/give_training_item_screen.dart';

import 'manage_department.dart';
import 'manage_org_members.dart';
import 'package:versa_tribe/extension.dart';

class ManageAdminScreen extends StatefulWidget {

  final String orgNAME;
  final int orgID;
  const ManageAdminScreen({required this.orgNAME,required this.orgID, super.key});
  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}
class _ManageAdminScreenState extends State<ManageAdminScreen> {

  @override
  Widget build(BuildContext context) {
    debugPrint("orgID***--->${widget.orgID}");
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.kWhiteColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
        ),
        centerTitle: true,
        title: Text(widget.orgNAME,
            style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<ProfileResponse>(
              future: ApiConfig().getProfileData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return SizedBox(
                    height: size.height*0.21,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }else if(snapshot.connectionState==ConnectionState.done){
                  return containerProfile(snapshot, size);
                }else{
                  debugPrint("<-problem-------Admin data get------>");
                }
                return Container();
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.manageDepartment),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageDepartment(orgId: widget.orgID)));
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.manageTraining),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageTrainingScreen(orgId: widget.orgID)));
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.manageRoles),
              onTap: (){
                //_navigateToNextScreen(context,'ManageOrganization');
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.manageOrgMembers),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageOrgMembers(orgNAME: widget.orgNAME,orgID: widget.orgID,)));
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.contactSuperAdmin),
              onTap: (){

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget containerButton({required height,required text}){
    return Container(
      margin: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      height: height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: CustomColors.kBlueColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(text, style: const TextStyle(color: CustomColors.kWhiteColor, fontSize: 14, fontFamily: 'Poppins')),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_sharp, color: CustomColors.kWhiteColor, size: 20)
          ],
        ),
      ),
    );
  }


  Widget containerProfile(snapshot, size) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
      ),
      margin: EdgeInsets.only(
        top: size.height * 0.015,
        bottom: size.height * 0.02,
        left: size.width * 0.03,
        right: size.width * 0.03,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CustomColors.kBlueColor, width: 2),
          ),),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: CustomColors.kWhiteColor,
                  radius: 40,
                  child: Image.asset(ImagePath.profilePath)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height*0.03,horizontal: size.width*0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.orgNAME,style: const TextStyle(color: CustomColors.kBlackColor,fontSize: 14, fontFamily: 'Poppins')),
                  const SizedBox(height: 2),
                  Text(snapshot.data?.tOwner ?? '', style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins')),
                ]
                ),
              ),
              const Spacer(),
              InkWell(
                child: SvgPicture.asset(ImagePath.editProfileIcon,height: 15,width: 15,colorFilter: const ColorFilter.mode(CustomColors.kBlackColor,BlendMode.srcIn)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateAdminProfile(orgName: widget.orgNAME,orgId:widget.orgID)));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
