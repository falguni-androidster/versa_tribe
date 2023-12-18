import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:versa_tribe/extension.dart';

class RequestedOrganizationScreen extends StatefulWidget {
  const RequestedOrganizationScreen({super.key});

  @override
  State<RequestedOrganizationScreen> createState() => _RequestedOrganizationScreenState();
}

class _RequestedOrganizationScreenState extends State<RequestedOrganizationScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
          future: ApiConfig.getManageOrgData(context: context, tabIndex: 0),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: size.height * 0.21,
                child: const Center(child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<DisplayManageOrgProvider>(
                  builder: (context, val, child) {
                    return val.requestOrgDataList.isNotEmpty ?
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: val.requestOrgDataList.length,
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
                                              text: TextSpan(text: CustomString.requestedToJoin,
                                                  style: DefaultTextStyle.of(context).style,
                                                  children: [
                                                    TextSpan(
                                                        text: val.requestOrgDataList[index].orgName ?? "",
                                                        style: const TextStyle(color: CustomColors.kBlueColor, fontFamily: 'Poppins'))
                                                  ]),
                                            )),
                                        SizedBox(height: size.height * 0.005),
                                        Text("${CustomString.requestedDepartment} ${val.requestOrgDataList[index].deptName ?? val.requestOrgDataList[index].deptReq}",
                                            style: const TextStyle(fontSize: 10, color: CustomColors.kLightGrayColor, fontFamily: 'Poppins'))
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: CustomColors.kGrayColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                                      onPressed: () {
                                        ApiConfig.deleteOrgRequest(context: context, orgID: val.requestOrgDataList[index].orgId, personID: val.requestOrgDataList[index].personId, screen: CustomString.requested);
                                      },
                                      child: const Text(
                                          CustomString.cancel,
                                          style: TextStyle(fontSize: 12,color: CustomColors.kBlackColor, fontFamily: 'Poppins')
                                      )
                                  ),
                                ],
                              ),
                            );
                        }) :
                    Center(
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
    );
  }
}
