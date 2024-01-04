import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import '../Utils/svg_btn.dart';
import 'Home/account_screen.dart';
import 'Home/messenger_screen.dart';
import 'org_admin_manage.dart';
import 'manage_organization_screen.dart';
import 'package:versa_tribe/extension.dart';

class HomeScreen extends StatefulWidget {

  final String? from;
  final bool? popUp;
  const HomeScreen({super.key, this.from, this.popUp});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<OrgAdminPersonList> orgAdminPersonList = [];
  String? selectedValue;
  int? orgId;
  bool? orgAdmin;
  late SharedPreferences pref;

  @override
  initState() {
    setInitialValue(context);
    ApiConfig().getProfileData();
    super.initState();
  }

  setInitialValue(context) async {
    pref = await SharedPreferences.getInstance();
    final selectedOrgProvider = Provider.of<OrganizationProvider>(context, listen: false);
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    await ApiConfig.getDataSwitching(context: context);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    if(adminPersonList.isNotEmpty) {
      selectedValue = adminPersonList[0].orgName!;
      orgId = adminPersonList[0].orgId!;
      orgAdmin = adminPersonList[0].isAdmin!;
      orgAdminPersonList = adminPersonList;
      pref.getSharedPrefStringValue(key: "OrganizationName") == adminPersonList[0].orgName! || pref.getSharedPrefStringValue(key: "OrganizationName") == null ?
      await selectedOrgProvider.setSwitchOrganization(selectedValue, orgId, orgAdmin) :
      await selectedOrgProvider.setSwitchOrganization(pref.getSharedPrefStringValue(key: "OrganizationName"), pref.getSharedPrefIntValue(key: "OrganizationId"), pref.getSharedPrefBoolValue(key: "OrgAdmin"));
      if(widget.popUp == true &&  selectedOrgProvider.switchOrganization != null){
        _showDialog();
      }
    }
    return adminPersonList;
  }

  checkUser() async {
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);
    List<OrgAdminPersonList> adminPersonList = switchProvider.switchData.orgAdminPersonList!;
    if(adminPersonList.isNotEmpty) {
      //selectedValue = adminPersonList[0].orgName!;
      orgId = adminPersonList[0].orgId!;
      orgAdmin = adminPersonList[0].isAdmin!;
      orgAdminPersonList = adminPersonList;
    }
    return adminPersonList;
  }

  manageOrganization({context, val, finalPersonAdminList}) async{
    await pref.setSharedPrefStringValue(key: "OrganizationName", finalPersonAdminList.orgName!);
    await pref.setSharedPrefBoolValue(key: "OrgAdmin", finalPersonAdminList.isAdmin!);
    await pref.setSharedPrefIntValue(key: "OrganizationId", finalPersonAdminList.orgId!);
    selectedValue = pref.getSharedPrefStringValue(key: "OrganizationName");
    orgAdmin = pref.getSharedPrefBoolValue(key: "OrgAdmin");
    orgId = pref.getSharedPrefIntValue(key: "OrganizationId");
    val.setSwitchOrganization(selectedValue, orgId, orgAdmin);
    Navigator.of(context).pop();

    FBroadcast.instance().broadcast("Key_Message", value: orgId);
  }

  // Function to show the dialog
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.height * 0.075,
                child: Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: CustomColors.kBlackColor),
                    backgroundColor: CustomColors.kGrayColor,
                    elevation: 0,
                    title: const Text(
                      CustomString.switchOrganization,
                      style: TextStyle(color: CustomColors.kBlueColor),
                    ),
                  ),
                ),
              ),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return ListView.builder(
                  itemCount: orgAdminPersonList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                            height: size.height * 0.05,
                            child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kBlueColor : CustomColors.kGrayColor,
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(" ${orgAdminPersonList[index].orgName!}",
                                        style: TextStyle(fontFamily: 'Poppins', color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kWhiteColor : null))
                                )
                            )
                        ),
                      onTap: () => manageOrganization(context: context, val: val, finalPersonAdminList: orgAdminPersonList[index])
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    final screenIndexProvider = Provider.of<ManageBottomTabProvider>(context);
    int currentScreenIndex = screenIndexProvider.currentTab;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: const Text(CustomString.dialogTitle, style: TextStyle(fontFamily: 'Poppins')),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(CustomString.dialogNo, style: TextStyle(fontFamily: 'Poppins')),
                ),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text(CustomString.dialogYes, style: TextStyle(fontFamily: 'Poppins'))),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shadowColor: CustomColors.kBlackColor,
          elevation: 6,
          backgroundColor: CustomColors.kWhiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.switchOrganization?.length != null
                    ? InkWell(
                        child: Row(
                          children: [
                            Text("${val.switchOrganization}  ",
                                style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins')),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.transparent,
                              child: SVGIconButton(svgPath: ImagePath.dropdownIcon, size: 6.0, color: CustomColors.kLightGrayColor,
                                  onPressed: () async {
                                    await ApiConfig.getDataSwitching(context: context);
                                    checkUser();
                                    _showDialog();
                                  }),
                            ),
                          ],
                        ),
                        onTap: () async {
                          await ApiConfig.getDataSwitching(context: context);
                          checkUser();
                          _showDialog();
                        },
                      )
                    : TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOrganization()));
                        },
                        child: const Text(CustomString.joinOrg,
                            style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')));
              }),
              const Spacer(),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.isAdmin==true || orgAdmin== true
                    ? SVGIconButton(svgPath: ImagePath.switchIcon, size: 24.0, color: CustomColors.kBlueColor,
                        // Replace with the path to your SVG asset
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(orgNAME: val.switchOrganization ?? selectedValue!, orgID: val.switchOrgId ?? orgId!)));
                        })
                    : Container();
              })
            ],
          ),
        ),
        ///Bottom navigation bar 1
        bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS? NavigationBar(
          onDestinationSelected: (int index) {
            screenIndexProvider.manageBottomTab(index);
          },
          elevation: 10,
          height: size.height * 0.07,
          shadowColor: CustomColors.kLightGrayColor,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          backgroundColor: CustomColors.kWhiteColor,
          indicatorColor: CustomColors.kPrimaryColor,
          selectedIndex: currentScreenIndex,
          destinations: <Widget>[
            NavigationDestination(
                selectedIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.dashboard),
            NavigationDestination(
                selectedIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.project),
            NavigationDestination(
                selectedIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.training),
            NavigationDestination(
                selectedIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.messenger),
            NavigationDestination(
                selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                label: CustomString.account),
          ],
        ):
        Card(
          elevation: 3,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: size.height * 0.02, left: size.width * 0.03, right: size.width * 0.03),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              screenIndexProvider.manageBottomTab(index);
            },
            animationDuration: const Duration(seconds: 1),
            elevation: 3,
            height: size.height * 0.1,
            shadowColor: CustomColors.kLightGrayColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            backgroundColor: CustomColors.kWhiteColor,
            indicatorColor: CustomColors.kPrimaryColor,
            selectedIndex: currentScreenIndex,
            destinations: <Widget>[
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.dashboard),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.project),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.training),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.messenger),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.account),
            ],
          ),
        ),

          ///Bottom navigation bar 2
          /*bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS? NavigationBar(
            onDestinationSelected: (int index) {
              screenIndexProvider.manageBottomTab(index);
            },
            elevation: 10,
            height: size.height*0.07,
            shadowColor: CustomColors.kLightGrayColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            backgroundColor: CustomColors.kWhiteColor,
            indicatorColor: CustomColors.kPrimaryColor,
            selectedIndex: currentScreenIndex,
            destinations: <Widget>[
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.dashboard),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.project),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.training),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.messenger),
              NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                  label: CustomString.account),
            ],
          ):
          Card(
            elevation: 3,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: size.height*0.02,left: size.width*0.03,right: size.width*0.03),
            child: BottomNavigationBar(
              onTap: (int index){
                screenIndexProvider.manageBottomTab(index);
              },
              elevation: 3,
              currentIndex: currentScreenIndex,
              selectedItemColor: CustomColors.kBlueColor,
              backgroundColor: CustomColors.kWhiteColor,
              items: [
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                    icon: SvgPicture.asset(ImagePath.dashboard, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                    label: CustomString.dashboard),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                    icon: SvgPicture.asset(ImagePath.project, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                    label: CustomString.project),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                    icon: SvgPicture.asset(ImagePath.training, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                    label: CustomString.training),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                    icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                    label: CustomString.messenger),
                BottomNavigationBarItem(
                    activeIcon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor,BlendMode.srcIn)),
                    icon: SvgPicture.asset(ImagePath.account, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor,BlendMode.srcIn)),
                    label: CustomString.account),
              ],
            ),
          ),*/
        body: <Widget>[
          const DashboardScreen(),
          ///Project TAB
          Consumer<OrganizationProvider>(
            builder: (context,val,child) {
              return ProjectScreen(orgId: val.switchOrgId);
            }
          ),
          ///Training TAB
          Consumer<OrganizationProvider>(
          builder: (context,val,child) {
              return TrainingScreen(orgId: val.switchOrgId);
            }
          ),
          const MessengersScreen(),
          const AccountScreen()
        ][currentScreenIndex]
      ),
    );
  }
}
