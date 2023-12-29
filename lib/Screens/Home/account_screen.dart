import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/person_details_screen.dart';
import '../../Utils/svg_btn.dart';
import '../manage_organization_screen.dart';
import '../sign_in_screen.dart';
import 'package:versa_tribe/extension.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.kWhiteColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: size.height * 0.01),

            FutureBuilder<ProfileResponse>(
              future: ApiConfig().getProfileData(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return SizedBox(
                    height: size.height*0.21,
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
                    logoutClick(context);
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

  Future<void> logoutClick(context) async {
    final provider = Provider.of<ManageBottomTabProvider>(context, listen: false);
    String logOutUrl = '${ApiConfig.baseUrl}/api/Account/Logout';
    final response = await http.post(Uri.parse(logOutUrl));
    if (response.statusCode == 200) {
      provider.manageBottomTab(0);
      clearSharedPreferences(CustomString.isLoggedIn);
      clearSharedPreferences("OrganizationName");
      showToast(context, CustomString.logOutSuccess);
      if (!mounted) return;
      _navigateToNextScreen(context, 'signInScreen');
    } else {
      showToast(context, CustomString.somethingWrongMessage);
    }
  }

  // Navigate to next Screen
  void _navigateToNextScreen(BuildContext context, String screen) {
    if (screen == 'signInScreen') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
    } else if (screen == 'ManageOrganization') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ManageOrganization()));
    } else if (screen == 'PersonDetails') {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PersonDetailsScreen()));
    }
  }

  // Only Clear LoggedIn SharedPreference
  void clearSharedPreferences(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                backgroundColor: CustomColors.kWhiteColor,
                radius: 40,
                child: Image.asset(ImagePath.profilePath)),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${snapshot.data?.firstName ?? ''} ${snapshot.data?.lastName ?? ''}',
                      style: const TextStyle(
                          color: CustomColors.kWhiteColor, fontSize: 16,fontFamily: 'Poppins')),
                  const SizedBox(height: 2),
                  Text(snapshot.data?.tOwner ?? '',
                      style: const TextStyle(
                          color: CustomColors.kWhiteColor, fontSize: 14,fontFamily: 'Poppins')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
