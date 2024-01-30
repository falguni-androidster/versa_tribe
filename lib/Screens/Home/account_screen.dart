import 'package:flutter/material.dart';
import 'package:versa_tribe/Screens/person_details_screen.dart';
import '../../Utils/svg_btn.dart';
import '../manage_organization_screen.dart';
import 'package:versa_tribe/extension.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig().getProfileData();
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: size.height * 0.01),

              FutureBuilder<ProfileDataModel>(
                future: ApiConfig().getProfileData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox(
                      height: size.height * 0.21,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  else if(snapshot.connectionState == ConnectionState.done){
                    return containerProfile(snapshot);
                  }else{
                    debugPrint("-----Profile print future builder in Account screen------");
                  }
                  return Container();
                },
              ),

              SizedBox(height: size.height * 0.01),

              InkWell(
                child: containerButton(
                    height: size.height * 0.06,
                    text: CustomString.personDetails),
                onTap: () {
                  _navigateToNextScreen(context, 'PersonDetails');
                },
              ),

              InkWell(
                child: containerButton(
                    height: size.height * 0.06,
                    text: CustomString.manageOrganization),
                onTap: () {
                  _navigateToNextScreen(context, 'ManageOrganization');
                },
              ),

              InkWell(
                child: containerButton(
                    height: size.height * 0.06,
                    text: CustomString.settings),
                onTap: () {
                  // logoutClick(context);
                },
              ),

              InkWell(
                child: containerButton(
                    height: size.height * 0.06,
                    text: CustomString.help),
                onTap: () {
                  // logoutClick(context);
                },
              ),

              InkWell(
                child: containerButton(
                    height: size.height * 0.06,
                    text: CustomString.about),
                onTap: () {
                  // logoutClick(context);
                },
              ),

              Container(
                height: size.height * 0.06,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.2, vertical: size.height * 0.02),
                child: MaterialButton(
                    onPressed: () {
                      ApiConfig().logoutClick(context);
                    },
                    color: CustomColors.kGrayColor,
                    elevation: 6,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        const Text(CustomString.logout,
                            style: TextStyle(
                                color: CustomColors.kLightGrayColor,
                                fontSize: 16,
                                fontFamily: 'Poppins')),
                        SVGIconButton(
                            svgPath: ImagePath.logoutIcon,
                            onPressed: () {},
                            size: 18,
                            color: CustomColors.kLightGrayColor)
                      ],
                    )
                ),
              ),
              const Text(CustomString.version,
                  style: TextStyle(fontSize: 16, color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
            ],
          ),
        ),
      ),
    );
  }

  Widget containerButton({required height, required text}) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: CustomColors.kBlueColor),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(text,
                style: const TextStyle(
                    color: CustomColors.kWhiteColor, fontSize: 16,fontFamily: 'Poppins')),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_sharp,color: CustomColors.kWhiteColor,size: 20)
          ],
        ),
      ),
    );
  }

  // Navigate to next Screen
  void _navigateToNextScreen(BuildContext context, String screen) {
    if (screen == 'ManageOrganization') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ManageOrganization()));
    } else if (screen == 'PersonDetails') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PersonDetailsScreen()));
    }
  }

  Widget containerProfile(snapshot) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: CustomColors.kBlueColor),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: size.height * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: CustomColors.kWhiteColor,
                radius: 40,
                child: Image.asset(ImagePath.profilePath)),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                      style: const TextStyle(
                          color: CustomColors.kWhiteColor, fontSize: 16,fontFamily: 'Poppins')),
                  const SizedBox(height: 2),
                  Text(snapshot.data?.tOwner ?? '',
                      style: const TextStyle(
                          color: CustomColors.kWhiteColor, fontSize: 12,fontFamily: 'Poppins')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
