import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/Screens/Organization/approved_organization_screen.dart';
import 'package:versa_tribe/Screens/Organization/requested_organization_screen.dart';
import 'package:versa_tribe/extension.dart';

class ManageOrganization extends StatefulWidget {
  const ManageOrganization({super.key});
  @override
  State<ManageOrganization> createState() => _ManageOrganizationState();
}

class _ManageOrganizationState extends State<ManageOrganization>
    with SingleTickerProviderStateMixin {
  final List<String> margList = [];
  List<String> finalList = [];
  List<String> orgAdminList = [];
  late OrgNameId oPData;
  late OrgNameId oAData;
  String? selectedValue;

  TextEditingController organizationNameController = TextEditingController();
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController requestNewDepartmentController = TextEditingController();

  late TabController _tabController;
  late int orgID;
  int? dpID;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
          onTap: () {
            arrowBackPressed(context);
          },
        ),
        title: const Text(CustomString.manageOrganization,
            style: TextStyle(
                color: CustomColors.kBlueColor,fontSize: 16, fontFamily: 'Poppins')),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                organizationNameController.clear();
                departmentNameController.clear();
                requestNewDepartmentController.clear();
                joinOrganizationDialog(context: context, mHeight: size.height, mWidth: size.width);
              },
              icon: const Icon(
                Icons.add,
                color: CustomColors.kBlackColor,
              ))
        ],
      ),

      /// request Button for join org
      /*     floatingActionButton: FloatingActionButton.extended(
        label: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(Icons.add_circle_outline,
                  color: CustomColors.kWhiteColor),
            ),
            Text(
              CustomString.joinOrganization,
              style: TextStyle(color: CustomColors.kWhiteColor),
            )
          ],
        ),
        backgroundColor: CustomColors.kBlueColor,
        onPressed: () {
          joinOrganizationDialog(context: context, mHeight: size.height, mWidth: size.width);
        },
      ),*/
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.02,
                left: size.width * 0.02,
                right: size.height * 0.02),
            child: TabBar(
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 5),
              controller: _tabController,
              indicator: BoxDecoration(borderRadius: BorderRadius.circular(5), color: CustomColors.kBlueColor),
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelStyle: const TextStyle(fontSize: 14, color: CustomColors.kBlackColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 14, color: CustomColors.kWhiteColor, fontWeight: FontWeight.w400, fontFamily: 'Poppins'),
              tabs: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(CustomString.requested)),
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(CustomString.approved)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                ///Requested
                RequestedOrganizationScreen(),

                ///Approved
                ApprovedOrganizationScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> joinOrganizationDialog({context, mHeight, mWidth}) async {
    final orgProvider = Provider.of<SearchOrgProvider>(context, listen: false);
    final departmentProvider = Provider.of<SearchDepartmentProvider>(context, listen: false);
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierColor: CustomColors.kLightGrayColor.withOpacity(0.8),
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Form(
                key: formKey,
                child: Container(
                  color: CustomColors.kWhiteColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppBar(
                        backgroundColor: CustomColors.kGrayColor,
                        leading: InkWell(
                          child: const Icon(Icons.arrow_back_ios, color: CustomColors.kBlackColor),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        title: const Text(CustomString.joinOrganization,
                            style: TextStyle(color: CustomColors.kBlueColor,fontSize: 14, fontFamily: 'Poppins')),
                        centerTitle: true,
                      ),

                      /// Organization Name text form field
                      Padding(
                        padding: EdgeInsets.only(
                            left: mWidth * 0.02,
                            right: mWidth * 0.02,
                            top: mHeight * 0.02,
                            bottom: mHeight * 0.01),
                        child: SizedBox(
                          height: mHeight*0.06,
                          child: TextFormField(
                            controller: organizationNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return CustomString.organizationNameRequired;
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (value != "") {
                                apiConfig.searchOrganization(context: context, orgString: value);
                                orgProvider.orgList.clear();
                              }
                              orgProvider.orgList.clear();
                              orgProvider.setVisible(true);
                            },
                            decoration: const InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              hintText: CustomString.organizationName,
                              hintStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'),
                            ),
                            style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      Consumer<SearchOrgProvider>(builder: (context, val, child) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: val.orgList.length,
                            itemBuilder: (context, index) {
                              return val.visible == true
                                  ? InkWell(
                                      child: Card(
                                        shadowColor: CustomColors.kBlueColor,
                                        elevation: 3,
                                        color: CustomColors.kGrayColor,
                                        child: Container(
                                            padding: EdgeInsets.only(left: mWidth * 0.02),
                                            height: mHeight * 0.05,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '${val.orgList[index].orgName}',
                                                style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
                                      ),
                                      onTap: () async {
                                        orgID = val.orgList[index].orgId!;
                                        organizationNameController.text = val.orgList[index].orgName ?? organizationNameController.text;
                                        val.setVisible(false);
                                      },
                                    )
                                  : Container();
                            });
                      }),

                      /// Department Name text form field
                      Padding(
                        padding: EdgeInsets.only(
                            left: mWidth * 0.02,
                            right: mWidth * 0.02,
                            top: mHeight * 0.01,
                            bottom: mHeight * 0.01),
                        child: SizedBox(
                          height: mHeight*0.06,
                          child: TextFormField(
                            controller: departmentNameController,
                            onChanged: (value) {
                              requestNewDepartmentController.clear();
                              if (value != "") {
                                apiConfig.searchDepartment(context: context, orgId: orgID);
                                departmentProvider.departmentList.clear();
                              }
                              departmentProvider.departmentList.clear();
                              departmentProvider.setVisible(true);
                            },
                            validator: (value) {
                              if (requestNewDepartmentController.text == "") {
                                if (value!.isEmpty) {
                                  return CustomString.departmentNameRequired;
                                } else {
                                  return null;
                                }
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              fillColor: CustomColors.kWhiteColor,
                              labelText: CustomString.departmentName,
                              labelStyle: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                            ),
                            style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      Consumer<SearchDepartmentProvider>(builder: (context, val, child) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: val.departmentList.length,
                            itemBuilder: (context, index) {
                              return val.visible == true
                                  ? InkWell(
                                      child: Card(
                                        shadowColor: CustomColors.kBlueColor,
                                        elevation: 3,
                                        color: CustomColors.kGrayColor,
                                        child: Container(
                                            padding: EdgeInsets.only(left: mWidth * 0.02),
                                            height: mHeight * 0.05,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                '${val.departmentList[index].deptName}',
                                                style: const TextStyle(color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))),
                                      ),
                                      onTap: () async {
                                        dpID = val.departmentList[index].deptId!;
                                        departmentNameController.text = val.departmentList[index].deptName ?? departmentNameController.text;
                                        val.setVisible(false);
                                      },
                                    )
                                  : Container();
                            });
                      }),

                      const Text('Or',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),

                      /// Request New Department text form field
                      Padding(
                        padding: EdgeInsets.only(
                            left: mWidth * 0.02,
                            right: mWidth * 0.02,
                            top: mHeight * 0.01,
                            bottom: mHeight * 0.01),
                        child: SizedBox(
                          height: mHeight*0.06,
                          child: TextFormField(
                            controller: requestNewDepartmentController,
                            onTap: () {
                              dpID=null;
                              departmentNameController.clear();
                            },
                            decoration: const InputDecoration(
                              fillColor: CustomColors.kWhiteColor,
                              labelText: CustomString.requestNewDepartment,
                              labelStyle: TextStyle(color: CustomColors.kLightGrayColor, fontSize: 12, fontFamily: 'Poppins'),
                            ),
                            style: const TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),

                      /// Elevated Submit Button
                      Padding(
                        padding: EdgeInsets.only(
                            left: mWidth * 0.02,
                            right: mWidth * 0.02,
                            top: mHeight * 0.01,
                            bottom: mHeight * 0.01),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                String? dpName = requestNewDepartmentController.text;
                                if (formKey.currentState!.validate()) {
                                  apiConfig.joinOrgRequest(context: context, orgID: orgID, dpID: dpID, dpName: dpName);
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CustomColors.kBlueColor),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: const BorderSide(color: CustomColors.kBlueColor)))),
                              child: const Text(CustomString.sendRequest,
                                  style: TextStyle(color: CustomColors.kWhiteColor, fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  arrowBackPressed(context) async {
    await apiConfig.getDataSwitching(context: context);
    Navigator.pushNamed(context, '/home');
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
  }
}
