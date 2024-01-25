import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:versa_tribe/Screens/Home/dashboard_screen.dart';
import 'package:versa_tribe/Screens/Home/project_screen.dart';
import 'package:versa_tribe/Screens/Home/training_screen.dart';
import '../Utils/svg_btn.dart';
import 'Home/account_screen.dart';
// import 'Home/messenger_screen.dart';
import 'org_admin_manage.dart';
import 'manage_organization_screen.dart';
import 'package:versa_tribe/extension.dart';

class HomeScreen extends StatefulWidget {

  final String? from;
  final bool? popUp;
  final SIPUAHelper? helper;

  const HomeScreen({super.key, this.from, this.popUp, this.helper});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements SipUaHelperListener{

  List<OrgAdminPersonList> orgAdminPersonList = [];
  String? selectedValue;
  int? orgId;
  bool? orgAdmin;
  late SharedPreferences pref;

  late RegistrationState registerState;
  SIPUAHelper? get helper => widget.helper;

  @override
  initState() {
    setInitialValue(context);
    super.initState();
    registerState = helper!.registerState;
    helper!.addSipUaHelperListener(this);
  }

  @override
  void deactivate() {
    super.deactivate();
    helper!.removeSipUaHelperListener(this);
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {
      registerState = state;
    });
  }

  void _handleSave(BuildContext context) {
    UaSettings settings = UaSettings();

    settings.webSocketUrl = 'wss://wazo.gigonomy.in:5040/ws';
    settings.webSocketSettings.allowBadCertificate = true;
    settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

    settings.uri = 'os0i7i7y@wazo.gigonomy.in';
    settings.authorizationUser = 'os0i7i7y';
    settings.password = 'ejfcvo8y';
    settings.displayName = 'Falguni';
    settings.userAgent = 'Dart SIP Client v1.0.0';
    settings.dtmfMode = DtmfMode.RFC2833;

    helper!.start(settings);
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
      pref.getSharedPrefStringValue(key: CustomString.organizationName) == adminPersonList[0].orgName! || pref.getSharedPrefStringValue(key: CustomString.organizationName) == null ?
      await selectedOrgProvider.setSwitchOrganization(selectedValue, orgId, orgAdmin) :
      await selectedOrgProvider.setSwitchOrganization(pref.getSharedPrefStringValue(key: CustomString.organizationName), pref.getSharedPrefIntValue(key: CustomString.organizationId), pref.getSharedPrefBoolValue(key: CustomString.organizationAdmin));
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
    await pref.setSharedPrefStringValue(key: CustomString.organizationName, finalPersonAdminList.orgName!);
    await pref.setSharedPrefBoolValue(key: CustomString.organizationAdmin, finalPersonAdminList.isAdmin!);
    await pref.setSharedPrefIntValue(key: CustomString.organizationId, finalPersonAdminList.orgId!);
    selectedValue = pref.getSharedPrefStringValue(key: CustomString.organizationName);
    orgAdmin = pref.getSharedPrefBoolValue(key: CustomString.organizationAdmin);
    orgId = pref.getSharedPrefIntValue(key: CustomString.organizationId);
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
                    centerTitle: true,
                    title: const Text(
                      CustomString.switchOrganization,
                      style: TextStyle(color: CustomColors.kBlueColor),
                    ),
                  ),
                ),
              ),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return Container(
                  color: CustomColors.kWhiteColor,
                  padding: EdgeInsets.only(left: size.width * 0.01, right: size.width * 0.01, bottom: size.height * 0.01),
                  child: ListView.builder(
                    itemCount: orgAdminPersonList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          child: SizedBox(
                              height: size.height * 0.05,
                              child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kBlueColor : CustomColors.kGrayColor,
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(" ${orgAdminPersonList[index].orgName!}",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontFamily: 'Poppins', color: val.switchOrganization == orgAdminPersonList[index].orgName! ? CustomColors.kWhiteColor : null))
                                  )
                              )
                          ),
                        onTap: () => manageOrganization(context: context, val: val, finalPersonAdminList: orgAdminPersonList[index])
                      );
                    },
                  ),
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
                return val.switchOrganization?.length != null ? InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01, right: size.width * 0.01),
                    child: Row(
                      children: [
                        Text("${val.switchOrganization}  ",
                            style: const TextStyle(color: CustomColors.kBlueColor, fontSize: 16, fontFamily: 'Poppins')),
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.transparent,
                          child: SVGIconButton(
                              svgPath: ImagePath.dropdownIcon, size: 6.0, color: CustomColors.kLightGrayColor,
                              onPressed: () async {
                                await ApiConfig.getDataSwitching(context: context);
                                checkUser();
                                _showDialog();
                              }),
                        )],
                    ),
                  ),
                  onTap: () async {
                    await ApiConfig.getDataSwitching(context: context);
                    checkUser();
                    _showDialog();
                    }) :
                TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageOrganization()));
                      },
                    child: const Text(CustomString.joinOrg,
                        style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')
                    )
                );
              }),
              const Spacer(),
              Consumer<CallSwitchProvider>(
                builder: (context, switchProvider, _) {
                  return Switch(
                    value: switchProvider.isSwitched,
                    activeColor: CustomColors.kBlueColor,
                    onChanged: (value) async {
                      if(value){
                        _handleSave(context);
                        await Permission.microphone.request();
                        await Permission.camera.request();
                      } else{
                        helper!.stop();
                      }
                      switchProvider.toggleSwitch();
                    },
                  );
                },
              ),
              SizedBox(width: size.width * 0.02),
              Consumer<OrganizationProvider>(builder: (context, val, child) {
                return val.isAdmin==true || orgAdmin== true
                    ? SVGIconButton(svgPath: ImagePath.switchIcon, size: 24.0, color: CustomColors.kBlueColor,
                        // Replace with the path to your SVG asset
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAdminScreen(orgNAME: val.switchOrganization ?? selectedValue!, orgID: val.switchOrgId ?? orgId!)));
                        })
                    : Container();
              }),

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
              /*NavigationDestination(
                  selectedIcon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kBlueColor, BlendMode.srcIn)),
                  icon: SvgPicture.asset(ImagePath.messenger, colorFilter: const ColorFilter.mode(CustomColors.kLightGrayColor, BlendMode.srcIn)),
                  label: CustomString.messenger),*/
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
          /*const MessengersScreen(),*/
          const AccountScreen()
        ][currentScreenIndex]
      ),
    );
  }

  @override
  void callStateChanged(Call call, CallState callState) {
    //NO OP
    if(callState.state == CallStateEnum.CALL_INITIATION){
      Navigator.pushNamed(context, '/callscreen', arguments: call);
    }
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void onNewMessage(SIPMessageRequest msg) {
    // NO OP
  }

  @override
  void onNewNotify(Notify ntf) {
    // NO OP
  }
}
