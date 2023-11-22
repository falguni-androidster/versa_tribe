import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:versa_tribe/Model/profile_response.dart';
import 'package:versa_tribe/Screens/OrgAdmin/update_admin_profile.dart';
import 'package:versa_tribe/Screens/person_details_screen.dart';
import 'package:versa_tribe/Utils/image_path.dart';

import '../../Utils/api_config.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/custom_string.dart';
import '../manage_organization_screen.dart';
import '../sign_in_screen.dart';
import 'manage_department.dart';

class ManageAdminScreen extends StatefulWidget {

  final String title;
  const ManageAdminScreen({required this.title, super.key});

  @override
  State<ManageAdminScreen> createState() => _ManageAdminScreenState();
}
class _ManageAdminScreenState extends State<ManageAdminScreen> {

  @override
  Widget build(BuildContext context) {

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
        title: Text(widget.title,
            style: const TextStyle(color: CustomColors.kBlueColor,fontFamily: 'Poppins')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<ProfileResponse>(
              future: ApiConfig().getProfileData(),
              builder: (context, snapshot) {
                return containerProfile(snapshot);
              },
            ),
            InkWell(
              child: containerButton(height: size.height * 0.06, text: CustomString.manageDepartment),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ManageDepartment()));
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
            Text(text,style: const TextStyle(color: CustomColors.kWhiteColor, fontSize: 14, fontFamily: 'Poppins')),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_sharp, color: CustomColors.kWhiteColor, size: 20)
          ],
        ),
      ),
    );
  }

  Widget containerProfile(snapshot){
    return Card(
      margin: const EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 20),
      elevation: 5,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: CustomColors.kWhiteColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(backgroundColor: CustomColors.kWhiteColor,radius: 40, child: Image.asset(ImagePath.profilePath)),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title?? '',style: const TextStyle(color: CustomColors.kBlackColor,fontSize: 14)),
                    Text('${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}', style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 14, fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    Text(snapshot.data?.tOwner ?? '', style: const TextStyle(color: CustomColors.kBlackColor, fontSize: 12, fontFamily: 'Poppins'))
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                child: SvgPicture.asset(ImagePath.editProfileIcon,height: 15,width: 15,colorFilter: const ColorFilter.mode(CustomColors.kBlackColor,BlendMode.srcIn)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateAdminProfile(orgName: widget.title??""/*snapshot.data?.firstName ?? ''*/)));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
