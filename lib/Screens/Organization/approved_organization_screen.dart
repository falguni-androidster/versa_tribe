import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_tribe/extension.dart';

class ApprovedOrganizationScreen extends StatefulWidget {
  const ApprovedOrganizationScreen({super.key});

  @override
  State<ApprovedOrganizationScreen> createState() => _ApprovedOrganizationScreenState();
}

class _ApprovedOrganizationScreenState extends State<ApprovedOrganizationScreen> {

  // Call this when the user pull down the screen
  Future<void> _loadData() async {
    try {
      ApiConfig.getManageOrgData(context: context, tabIndex: 1);
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: FutureBuilder(
            future: ApiConfig.getManageOrgData(context: context, tabIndex: 1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: size.height * 0.21,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Consumer<ApprovedManageOrgProvider>(
                    builder: (context, val, child) {
                  return val.approveOrgDataList.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: val.approveOrgDataList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: size.height * 0.08,
                              decoration: const BoxDecoration(
                                  border: BorderDirectional(bottom: BorderSide(width: 0.5), top: BorderSide(width: 0.1))),
                              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.005),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                  text: CustomString.requestApproved1,
                                              style: DefaultTextStyle.of(context).style,
                                              children: [
                                                TextSpan(
                                                    text: val.approveOrgDataList[index].orgName ?? "",
                                                    style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins')),
                                                const TextSpan(text: CustomString.requestApproved2,
                                                    style: TextStyle(fontFamily: 'Poppins'))
                                              ]),
                                        )),
                                        SizedBox(height: size.height * 0.005),
                                        Text(
                                            "${CustomString.department} ${val.approveOrgDataList[index].deptName ?? ""}",
                                            style: const TextStyle(fontSize: 10, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins')),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.kGrayColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                      onPressed: () {
                                        ApiConfig.deleteOrgRequest(context: context, orgID: val.approveOrgDataList[index].orgId, personID: val.approveOrgDataList[index].personId, screen: CustomString.approved);
                                      },
                                      child: const Text(CustomString.leave,
                                          style: TextStyle(color: CustomColors.kBlackColor, fontFamily: 'Poppins'))),
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.02),
                              SizedBox(
                                  height: size.height * 0.2,
                                  width: size.width / 1.5,
                                  child: Image.asset(ImagePath.noData, fit: BoxFit.fill)),
                              SizedBox(height: size.height * 0.2),
                              const Text(CustomString.noDataFound,
                                  style: TextStyle(color: CustomColors.kLightGrayColor))
                            ],
                          ),
                        );
                });
              }
              return Container();
            }),
      ),
    );
  }
}
